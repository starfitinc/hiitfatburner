import SwiftUI
import AVKit

struct HelpView: View {
    // Exemplo de URL do vídeo (substitua com o caminho do seu vídeo)
    let videoURL = URL(string: "https://www.example.com/video.mp4")!

    var body: some View {
        VStack(spacing: 20) { // Organiza os elementos verticalmente com espaçamento entre eles
            // Título no topo
            Text(NSLocalizedString("label_help", comment: ""))// lblHelp
                .font(.system(size: 30, weight: .bold)) // Configura tamanho e peso
                .frame(maxWidth: .infinity, alignment: .center) // Centraliza horizontalmente
                .padding(.top, 26)  // Adiciona margem superior

            // Espaço flexível para empurrar o vídeo para baixo
            Spacer()

            // Player de Vídeo
            VideoPlayer(player: AVPlayer(url: videoURL)) // Player com vídeo
                .frame(height: 200) // Define a altura do vídeo (ajustável)
                .padding(8) // Adiciona margem ao redor do player
        }
        .padding(8) // Padding geral do container
        .background(Color(UIColor.systemBackground)) // Cor de fundo
        .ignoresSafeArea() // Permite que o layout ocupe toda a tela
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
