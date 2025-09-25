import SwiftUI

struct HistoricView: View {
    @StateObject private var viewModel = HistoricViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.hiitList) { hiit in
                        HStack(alignment: .top, spacing: 10) {
                            // Coluna com linha vertical laranja
                            VStack {
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 5)
                                    .frame(maxHeight: .infinity)
                            }

                            VStack(alignment: .leading, spacing: 5) {
                                // 🔥 Ano agora encostado corretamente na linha laranja
                                ZStack {
                                    Rectangle()
                                        .fill(Color.orange)
                                        .frame(width: 65, height: 35)

                                    Text(formattedYear(hiit.hitDate))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .offset(x: -10)

                                // 🔥 Agora exibe apenas a data e o tempo total
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(formattedDate(hiit.hitDate))
                                        .font(.headline)
                                        .bold()

                                    Text(String(format: NSLocalizedString("label_total_time", comment: ""), hiit.hitTempoTotal))
                                        .font(.subheadline)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                }
            }
            .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(NSLocalizedString("label_historic", comment: ""))
                            .font(.system(size: 30, weight: .bold)) // Configura tamanho e peso
                            .frame(maxWidth: .infinity, alignment: .center) // Centraliza horizontalmente
                            .padding(.top, 20) 
                    }
                }
            .onAppear {
                viewModel.fetchHiitData()
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }

    private func formattedYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
}
