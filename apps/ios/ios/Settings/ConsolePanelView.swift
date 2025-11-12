//
//  ConsolePanelView.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  In-app console panel for viewing logs (debug builds only)

import SwiftUI

#if DEBUG
struct ConsolePanelView: View {
    @State private var logger = Logger.shared
    @State private var searchText = ""
    @State private var selectedLevel: LogLevel? = nil
    @State private var autoScroll = true
    
    private var filteredLogs: [LogEntry] {
        var logs = logger.getLogs()
        
        // Filter by search text
        if !searchText.isEmpty {
            logs = logs.filter { entry in
                entry.message.localizedCaseInsensitiveContains(searchText) ||
                (entry.category?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        // Filter by level
        if let level = selectedLevel {
            logs = logs.filter { $0.level == level }
        }
        
        return logs
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter controls
                VStack(spacing: 8) {
                    HStack {
                        TextField("Search logs...", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                        
                        Menu {
                            Button("All Levels") {
                                selectedLevel = nil
                            }
                            
                            ForEach(LogLevel.allCases, id: \.self) { level in
                                Button(level.rawValue) {
                                    selectedLevel = level
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    // Level filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                title: "All",
                                isSelected: selectedLevel == nil,
                                action: { selectedLevel = nil }
                            )
                            
                            ForEach(LogLevel.allCases, id: \.self) { level in
                                FilterChip(
                                    title: level.rawValue,
                                    isSelected: selectedLevel == level,
                                    action: { selectedLevel = level }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                Divider()
                
                // Log list
                if filteredLogs.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("No logs found")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        if !searchText.isEmpty || selectedLevel != nil {
                            Text("Try adjusting your filters")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollViewReader { proxy in
                        List(filteredLogs.reversed()) { entry in
                            LogEntryRow(entry: entry)
                                .id(entry.id)
                        }
                        .listStyle(.plain)
                        .onChange(of: filteredLogs.count) { _, _ in
                            if autoScroll, let lastLog = filteredLogs.last {
                                withAnimation {
                                    proxy.scrollTo(lastLog.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                // Bottom toolbar
                Divider()
                HStack {
                    Text("\(filteredLogs.count) log\(filteredLogs.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Toggle("Auto-scroll", isOn: $autoScroll)
                        .toggleStyle(.switch)
                        .labelsHidden()
                        .controlSize(.small)
                    
                    Button(action: {
                        logger.clearLogs()
                    }) {
                        Label("Clear", systemImage: "trash")
                            .font(.caption)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("Console")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ShareLink(item: logger.getLogsAsString()) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

private struct LogEntryRow: View {
    let entry: LogEntry
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(entry.level.color)
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(entry.formattedTimestamp)
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundStyle(.secondary)
                    
                    if let category = entry.category {
                        Text(category)
                            .font(.caption2)
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                Text(entry.message)
                    .font(.system(.caption, design: .default))
                    .textSelection(.enabled)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundStyle(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

#Preview {
    ConsolePanelView()
}
#endif

