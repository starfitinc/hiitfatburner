import SwiftUI
import AVFoundation


struct ContentView: View {
    var body: some View {
        TabView {
            // Primeira Aba: Cronômetro HIIT
            HIITView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            // Segunda Aba: Histórico
            HistoricView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Histórico")
                }

            // Terceira Aba: Referências
            ReferencesView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Referências")
                }

            // Quarta Aba: Ajuda
            HelpView()
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Ajuda")
                }
        }
        .accentColor(.green) // Cor principal para destacar a aba selecionada
    }
}

// MARK: - HIIT View
struct HIITView: View {
    @StateObject private var historicViewModel = HistoricViewModel()

    @State private var preparoTime = "00:00"
    @State private var exercicioTime = "00:00"
    @State private var descansoTime = "00:00"
    @State private var cycles = 0
    @State private var tempoTotal = "00:00"
    @State private var isRunning = false
    @State private var currentCycle = 0
    @State private var phase = "Preparo"
    @State private var currentTime = 0
    @State private var isPaused = false
    @State private var timer: Timer? = nil
    @State private var timeRemaining = "00:00"
    @State private var isTimerVisible = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if !isTimerVisible{
                    Text("Prepare HIIT")
                        .font(.system(size: 30, weight: .bold)) // Configura tamanho e peso
                        .frame(maxWidth: .infinity, alignment: .center) // Centraliza horizontalmente
                    

                    // Seções de Preparo, Exercício, Descanso
                    SectionView(title: NSLocalizedString("label_prepare", comment: ""), hintText: "mm:ss", time: $preparoTime)

                    SectionView(title: NSLocalizedString("label_exercise", comment: ""),  hintText: "mm:ss", time: $exercicioTime)
                    SectionView(title: NSLocalizedString("label_rest", comment: ""),  hintText: "mm:ss", time: $descansoTime)

                    // Seção de ciclos
                    CycleSectionView(cycles: $cycles, tempoTotal: $tempoTotal, preparoTime: $preparoTime, exercicioTime: $exercicioTime,
                                     descansoTime: $descansoTime)
                    // Seção de Tempo Total
                    TotalTimeSectionView(tempoTotal: $tempoTotal)

                    // Seção de Tempo Restante
                   


                    // Botão Iniciar
                    Button(action: {
                        let uniqueUUID = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
                        historicViewModel.saveHiitData(
                            hitQtdCiclos: cycles,
                            hitTempoDescanso: descansoTime,
                            hitTempoExercicio: exercicioTime,
                            hitTempoPreparo: preparoTime
                        )
                        startHIIT() // Inicia o cronômetro
                    }) {
                        Text( NSLocalizedString("btn_start", comment: ""))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .font(.title2)
                    }
                    .padding(.top, 20)
                }
                // Texto preparatório
                if isTimerVisible {
                    VStack {
                        Text(String(format: NSLocalizedString("label_phase", comment: ""), phase))
                            .font(.title2)
                            .padding(.bottom, 8)

                        HStack {
                            // Botão da esquerda
                            Button(action: {
                                // Ação esquerda (ex: diminuir ciclo)
                                if currentCycle > 0 {
                                    currentCycle -= 1
                                    
                                }
                            }) {
                                Image(systemName: "backward.end.fill")
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Color.orange)
                                    .clipShape(Circle())
                            }

                            Spacer()

                            // Cronômetro circular centralizado
                            CircularCountdownView(
                                progress: currentProgress(),
                                timeText: timeRemaining,
                                cycleText: "\(currentCycle + 1)/\(cycles)",
                                isPaused: isPaused,
                                onTogglePause: {
                                    isPaused.toggle()
                                }
                            )


                            Spacer()

                            // Botão da direita
                            Button(action: {
                                // Ação direita (ex: pular para próximo ciclo)
                                if currentCycle < cycles {
                                    currentCycle += 1
                                    
                                }
                            }) {
                                Image(systemName: "forward.end.fill")
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Color.orange)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                    HStack {
                        Spacer()
                        Image("logo")
                            .resizable()
                            .frame(width: 244, height: 85)
                        Spacer()
                    }

                }


                Spacer().frame(height: 16) // Espaço antes do vídeo
            }
            .padding(16)
        }
    }

    // Função para iniciar o cronômetro
    func startHIIT() {
        isRunning = true
        isTimerVisible = true
        currentCycle = 0
        phase = NSLocalizedString("label_phase_prepare", comment: "")
        startTimer(timeString: preparoTime, nextPhase: startExercise)
    }

    // Função para iniciar a fase de exercício
    func startExercise() {
        if currentCycle < cycles {
            phase = NSLocalizedString("label_phase_exercise", comment: "")
            startTimer(timeString: exercicioTime, nextPhase: startRest)
        } else {
            endHIIT()
        }
    }

    // Função para iniciar a fase de descanso
    func startRest() {
       
        phase = NSLocalizedString("label_phase_rest", comment: "")
        startTimer(timeString: descansoTime) {
            currentCycle += 1
            startExercise()
        }
    }

    // Função para iniciar o timer de cada fase
    func startTimer(timeString: String, nextPhase: @escaping () -> Void) {
        
        
        let timeComponents = timeString.split(separator: ":").map { Int($0) ?? 0 }
        let minutes = timeComponents[0]
        let seconds = timeComponents[1]
        currentTime = minutes * 60 + seconds
        timeRemaining = formatTime(currentTime)
    

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if !isPaused {
                if currentTime == 6 {
                    switch phase {
                    case NSLocalizedString("label_phase_prepare", comment: ""):
                        playSound(named: "audioprepare")

                    case NSLocalizedString("label_phase_exercise", comment: ""):
                        playSound(named: "audio_stop")

                    case NSLocalizedString("label_phase_rest", comment: ""):
                        playSound(named: "audiostart")

                    default:
                        break
                    }
                }
            
                
                if currentTime > 0 {
                    currentTime -= 1
                    timeRemaining = formatTime(currentTime)
                } else {
                    t.invalidate()
                    nextPhase()
                }
            }
        }
    }
    
    func playSound(named soundName: String) {
        if let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Erro ao tocar o som: \(error.localizedDescription)")
            }
        }
    }

    //calcular o progresso atual
    func currentProgress() -> Double {
        guard currentTime > 0 else { return 0.0 }
        let total = timeStringToSeconds(for: phase)
        return Double(currentTime) / Double(total)
    }

    func timeStringToSeconds(for phase: String) -> Int {
        let timeString: String
        switch phase {
        case NSLocalizedString("label_phase_prepare", comment: ""): timeString = preparoTime
        case NSLocalizedString("label_phase_exercise", comment: ""): timeString = exercicioTime
        case NSLocalizedString("label_phase_rest", comment: ""): timeString = descansoTime
        default: return 1
        }
        let parts = timeString.split(separator: ":").map { Int($0) ?? 0 }
        return parts[0] * 60 + parts[1]
    }


    // Função para encerrar o HIIT
    func endHIIT() {
        phase = "Finalizado"
        isRunning = false
        isTimerVisible = false
    }

    // Função para formatar o tempo
    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Seção Individual (Preparo, Exercício, Descanso)
struct SectionView: View {
    let title: String
    let hintText: String
    @Binding var time: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            HStack {
                TextField(hintText, text: $time)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)

                Button(action: {
                    // Ação para diminuir o tempo
                    time = decreaseTime(time: time)
                }) {
                    Text("-")
                }
                .frame(width: 50, height: 40)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button(action: {
                    // Ação para aumentar o tempo
                    time = increaseTime(time: time)
                }) {
                    Text("+")
                }
                .frame(width: 50, height: 40)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding(.top, 20)
    }

    private func increaseTime(time: String) -> String {
        let components = time.split(separator: ":").map { Int($0) ?? 0 }
        var minutes = components[0]
        var seconds = components[1]

        seconds += 1
        if seconds == 60 {
            seconds = 0
            minutes += 1
        }

        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func decreaseTime(time: String) -> String {
        let components = time.split(separator: ":").map { Int($0) ?? 0 }
        var minutes = components[0]
        var seconds = components[1]

        if seconds > 0 {
            seconds -= 1
        } else if minutes > 0 {
            minutes -= 1
            seconds = 59
        }

        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Seção de Ciclos
struct CycleSectionView: View {
    @Binding var cycles: Int
    @Binding var tempoTotal: String
    @Binding var preparoTime: String
    @Binding var exercicioTime: String
    @Binding var descansoTime: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NSLocalizedString("label_rounds", comment: ""))
                .font(.headline)

            HStack {
                TextField("Ex.: 08", text: .constant("\(cycles)"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(maxWidth: .infinity)

                Button(action: {
                    if cycles > 1 {
                        cycles -= 1
                        updateTotalTime()
                    }
                }) {
                    Text("-")
                }
                .frame(width: 50, height: 40)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button(action: {
                    cycles += 1
                    updateTotalTime()
                }) {
                    Text("+")
                }
                .frame(width: 50, height: 40)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding(.top, 20)
    }

    private func updateTotalTime() {
        let totalSeconds = (convertToSeconds(time: preparoTime) + (convertToSeconds(time: exercicioTime) + convertToSeconds(time: descansoTime)) * cycles)
        tempoTotal = formatTime(totalSeconds)
    }

    private func convertToSeconds(time: String) -> Int {
        let components = time.split(separator: ":").map { Int($0) ?? 0 }
        return components[0] * 60 + components[1]
    }

    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Seção de Tempo Total
struct TotalTimeSectionView: View {
    @Binding var tempoTotal: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NSLocalizedString("label_total", comment: ""))
                .font(.headline)

            TextField("00:00", text: $tempoTotal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(true)
        }
        .padding(.top, 20)
    }
}

// MARK: - Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
