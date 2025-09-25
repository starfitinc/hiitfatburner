import Foundation
import FirebaseFirestore

struct Hiit: Identifiable {
    var id: String
    var hitDate: Date
    var hitQtdCiclos: Int
    var hitTempoDescanso: String
    var hitTempoExercicio: String
    var hitTempoPreparo: String
    var hitTempoTotal: String
    var hitUniqueUUID: String

    init?(document: [String: Any], id: String) {
        guard let timestamp = document["hit_date"] as? Timestamp,
              let hitQtdCiclos = document["hit_qtd_ciclos"] as? Int,
              let hitTempoDescanso = document["hit_tempo_descanso"] as? String,
              let hitTempoExercicio = document["hit_tempo_exercicio"] as? String,
              let hitTempoPreparo = document["hit_tempo_preparo"] as? String,
              let hitTempoTotal = document["hit_tempo_total"] as? String,
              let hitUniqueUUID = document["hit_unique_UUID"] as? String else {
            return nil
        }

        self.id = id
        self.hitDate = timestamp.dateValue()
        self.hitQtdCiclos = hitQtdCiclos
        self.hitTempoDescanso = hitTempoDescanso
        self.hitTempoExercicio = hitTempoExercicio
        self.hitTempoPreparo = hitTempoPreparo
        self.hitTempoTotal = hitTempoTotal
        self.hitUniqueUUID = hitUniqueUUID
    }
}
