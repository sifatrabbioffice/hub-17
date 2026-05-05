import SwiftUI
import UniformTypeIdentifiers

@main
struct GameHubApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var hasStarted = false
    @State private var showFilePicker = false
    @State private var selectedExe: String = "No File Selected"

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if !hasStarted {
                // Phase 1: Launch Screen
                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1.2)) {
                            hasStarted = true
                        }
                    }) {
                        Text("CLICK TO START")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyan)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.cyan, lineWidth: 1))
                            .shadow(color: .cyan, radius: 10)
                    }
                    Spacer()
                }
            } else {
                // Phase 2: Emulator Interface
                VStack(spacing: 20) {
                    HStack {
                        Text("WIN-ENV X64").font(.headline).foregroundColor(.green)
                        Spacer()
                        Circle().frame(width: 10, height: 10).foregroundColor(.green).shadow(radius: 5)
                    }
                    .padding()

                    // Visual Game Box
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(Color(white: 0.1))
                        VStack {
                            Image(systemName: "cpu").font(.system(size: 50)).foregroundColor(.blue)
                            Text(selectedExe).font(.caption).foregroundColor(.gray).padding(.top)
                        }
                    }
                    .frame(height: 200).padding()

                    // Action Buttons
                    HStack(spacing: 20) {
                        Button("SELECT EXE") { showFilePicker = true }
                            .buttonStyle(GamingButtonStyle(color: .blue))
                        
                        Button("RUN DIRECTX") { /* Execute C++ Logic */ }
                            .buttonStyle(GamingButtonStyle(color: .green))
                    }
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .sheet(isPresented: $showFilePicker) {
            DocumentPicker(selectedFile: $selectedExe)
        }
    }
}

// Custom Button Style for High-End Look
struct GamingButtonStyle: ButtonStyle {
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

// File Picker to get EXE from iOS Storage
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedFile: String
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.executable])
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ ui: UIViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        init(_ parent: DocumentPicker) { self.parent = parent }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedFile = urls.first?.lastPathComponent ?? "Error"
        }
    }
}
