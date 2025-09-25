import Foundation
import FirebaseFirestore
import SwiftUI

class HistoricViewModel: ObservableObject {
    @Published var hiitList: [Hiit] = []
    
    private var db = Firestore.firestore()
    private var userUUID: String {
        if let uuid = UserDefaults.standard.string(forKey: "userUUID") {
            return uuid
        } else {
            let newUUID = UUID().uuidString
            UserDefaults.standard.set(newUUID, forKey: "userUUID")
            return newUUID
        }
    }

    // 🔥 Busca os treinos do usuário atual no Firestore
    func fetchHiitData() {
        db.collection("Hiit")
            .whereField("hit_unique_UUID", isEqualTo: userUUID) // Filtra pelo UUID do usuário
            .order(by: "hit_date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Erro ao buscar dados: \(error)")
                    return
                }
                
                self.hiitList = snapshot?.documents.compactMap { document in
                    Hiit(document: document.data(), id: document.documentID)
                } ?? []
            }
    }

    // 🔥 Salva um novo treino no Firestore
    func saveHiitData(hitQtdCiclos: Int,
                      hitTempoDescanso: String,
                      hitTempoExercicio: String,
                      hitTempoPreparo: String) {
        
        let collectionRef = db.collection("Hiit")
        
        // Obtém o último hit_id e incrementa +1
        collectionRef
            .order(by: "hit_id", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Erro ao obter último hit_id: \(error)")
                    return
                }
                
                let lastHitID = snapshot?.documents.first?["hit_id"] as? Int ?? 0
                let newHitID = lastHitID + 1
                
                // Converte tempos de string para segundos
                let tempoTotalSeconds = self.calculaTempoTotal(hitQtdCiclos, hitTempoDescanso, hitTempoExercicio, hitTempoPreparo)
                
                // Converte o tempo total de volta para "HH:mm"
                let totalTimeFormatted = self.formatarTempo(tempoTotalSeconds)
                
                // Criamos o novo documento
                let newHiitData: [String: Any] = [
                    "hit_id": newHitID,
                    "hit_qtd_ciclos": hitQtdCiclos,
                    "hit_tempo_descanso": hitTempoDescanso,
                    "hit_tempo_exercicio": hitTempoExercicio,
                    "hit_tempo_preparo": hitTempoPreparo,
                    "hit_tempo_total": totalTimeFormatted,
                    "hit_date": Timestamp(date: Date()),
                    "hit_unique_UUID": self.userUUID
                ]
                
                // Adiciona no Firestore
                collectionRef.document("\(newHitID)").setData(newHiitData) { error in
                    if let error = error {
                        print("Erro ao salvar treino: \(error)")
                    } else {
                        print("Treino salvo com sucesso com ID \(newHitID)!")
                        self.fetchHiitData() // Atualiza a lista após salvar
                    }
                }
            }
    }
    
    // 🔥 Calcula o tempo total em segundos
    private func calculaTempoTotal(_ ciclos: Int, _ descanso: String, _ exercicio: String, _ preparo: String) -> TimeInterval {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let descansoDate = formatter.date(from: descanso),
              let exercicioDate = formatter.date(from: exercicio),
              let preparoDate = formatter.date(from: preparo) else {
            return 0
        }
        
        let descansoSeconds = descansoDate.timeIntervalSince1970 * Double(ciclos)
        let exercicioSeconds = exercicioDate.timeIntervalSince1970 * Double(ciclos)
        let preparoSeconds = preparoDate.timeIntervalSince1970
        
        return descansoSeconds + exercicioSeconds + preparoSeconds
    }
    
    // 🔥 Formata tempo total para "HH:mm"
    private func formatarTempo(_ seconds: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date(timeIntervalSince1970: seconds))
    }
}
