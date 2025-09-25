//
//  ReferenceView.swift
//  HiitFatBurner
//
//  Created by Kornerz Ltda on 24/11/24.
//

import SwiftUI

struct ReferencesView: View {
    var body: some View {
        ScrollView { // Permite rolar o conteúdo
            VStack(alignment: .leading, spacing: 16) {
                // Título
                Text(NSLocalizedString("label_references", comment: ""))// lblHelp
                    .font(.system(size: 30, weight: .bold)) // Configura tamanho e peso
                    .frame(maxWidth: .infinity, alignment: .center)
               
                // Referências
                VStack(alignment: .leading, spacing: 8) {
                    ReferenceText(text: "BILLAT, L. Véronique. Interval training for performance: a scientific and empirical practice. Sports Medicine, v. 31, n. 1, p. 13-31, 2001.")
                   
                    ReferenceText(text: "BUCHHEIT, Martin; LAURSEN, Paul B. High-intensity interval training, solutions to the programming puzzle. Sports medicine, v. 43, n. 5, p. 313-338, 2013.")
                   
                    ReferenceText(text: "GIBALA, Martin J.; MCGEE, Sean L. Metabolic adaptations to short-term high-intensity interval training: a little pain for a lot of gain?. Exercise and sport sciences reviews, v. 36, n. 2, p. 58-63, 2008.")
                   
                    ReferenceText(text: "GIBALA, Martin J. et al. Physiological adaptations to low‐volume, high‐intensity interval training in health and disease. The Journal of physiology, v. 590, n. 5, p. 1077-1084, 2012.")
                   
                    ReferenceText(text: "MACINNIS, Martin J.; GIBALA, Martin J. Physiological adaptations to interval training and the role of exercise intensity. The Journal of physiology, v. 595, n. 9, p. 2915-2930, 2017.")
                   
                    ReferenceText(text: "TABATA, Izumi et al. Effects of moderate-intensity endurance and high-intensity intermittent training on anaerobic capacity and VO2max. Medicine and science in sports and exercise, v. 28, n. 10, p. 1327-1330, 1996.")
                   
                    ReferenceText(text: "WESTON, Kassia S.; WISLØFF, Ulrik; COOMBES, Jeff S. High-intensity interval training in patients with lifestyle-induced cardiometabolic disease: a systematic review and meta-analysis. Br J Sports Med, v. 48, n. 16, p. 1227-1234, 2014.")
                }
                .padding(8)
               
                Spacer()
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground)) // Fundo da tela
        .ignoresSafeArea(.all, edges: .bottom) // Ignora as áreas seguras, se necessário
    }
}

struct ReferenceText: View {
    let text: String
   
    var body: some View {
        Text(text)
            .font(.body)
            .multilineTextAlignment(.leading) // Alinha o texto à esquerda
            .lineLimit(nil)                  // Permite texto com múltiplas linhas
            .fixedSize(horizontal: false, vertical: true) // Garante que ele expanda verticalmente
            .padding(8)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
    }
}

struct ReferencesView_Previews: PreviewProvider {
    static var previews: some View {
        ReferencesView()
    }
}
