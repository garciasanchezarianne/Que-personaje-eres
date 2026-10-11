import SwiftUI

struct Question {
    let text: String
    let options: [AnswerOption]
}

struct AnswerOption {
    let title: String
    let points: [String: Int]
}

struct CharacterResult {
    let name: String
    let description: String
    let emoji: String
}

struct ContentView: View {
    // Personajes de Disney y descripciones originales para este cuestionario.
    private let characters: [String: CharacterResult] = [
        "Mickey Mouse": CharacterResult(
            name: "Mickey Mouse",
            description: "Eres optimista, amable y sabes mantener el ánimo incluso cuando algo sale mal. Tu entusiasmo ayuda a unir a las personas.",
            emoji: "🐭"
        ),
        "Mulan": CharacterResult(
            name: "Mulan",
            description: "Eres valiente, ingeniosa y perseverante. Te atreves a cuestionar lo establecido y buscas proteger a las personas que te importan.",
            emoji: "⚔️"
        ),
        "Simba": CharacterResult(
            name: "Simba",
            description: "Tienes un gran corazón y estás aprendiendo a confiar en ti. Afrontas los retos, creces con tus experiencias y valoras a tu comunidad.",
            emoji: "🦁"
        ),
        "Moana": CharacterResult(
            name: "Moana",
            description: "Eres curiosa, independiente y decidida. Te impulsa descubrir nuevos horizontes y seguir tu propósito aun cuando el camino es incierto.",
            emoji: "🌊"
        )
    ]

    // Cinco preguntas; cada respuesta aporta puntos a uno o varios personajes.
    private let questions: [Question] = [
        Question(text: "1. ¿Qué haces cuando aparece un gran desafío?", options: [
            AnswerOption(title: "Mantengo una actitud positiva y animo al equipo", points: ["Mickey Mouse": 2]),
            AnswerOption(title: "Pienso rápido y encuentro una estrategia", points: ["Mulan": 2]),
            AnswerOption(title: "Aprendo de lo ocurrido y doy la cara", points: ["Simba": 2]),
            AnswerOption(title: "Me atrevo a explorar un camino nuevo", points: ["Moana": 2])
        ]),
        Question(text: "2. ¿Qué valor es más importante para ti?", options: [
            AnswerOption(title: "La amistad y la alegría", points: ["Mickey Mouse": 2]),
            AnswerOption(title: "El valor y la responsabilidad", points: ["Mulan": 2]),
            AnswerOption(title: "La familia y el crecimiento personal", points: ["Simba": 2]),
            AnswerOption(title: "La libertad y descubrir quién soy", points: ["Moana": 2])
        ]),
        Question(text: "3. Si pudieras elegir una aventura, ¿cuál sería?", options: [
            AnswerOption(title: "Pasar un día divertido con mis amigos", points: ["Mickey Mouse": 2]),
            AnswerOption(title: "Resolver una misión que ayude a otros", points: ["Mulan": 2]),
            AnswerOption(title: "Recorrer mi hogar y recuperar la confianza", points: ["Simba": 2]),
            AnswerOption(title: "Navegar por el océano hacia lo desconocido", points: ["Moana": 2])
        ]),
        Question(text: "4. ¿Cómo reaccionas cuando alguien necesita ayuda?", options: [
            AnswerOption(title: "Le levanto el ánimo y le acompaño", points: ["Mickey Mouse": 2]),
            AnswerOption(title: "Busco una solución práctica, aunque sea difícil", points: ["Mulan": 2]),
            AnswerOption(title: "Me quedo a su lado y asumo mi responsabilidad", points: ["Simba": 2]),
            AnswerOption(title: "Le ayudo a encontrar su propio camino", points: ["Moana": 2])
        ]),
        Question(text: "5. ¿Qué frase te representa mejor?", options: [
            AnswerOption(title: "Siempre hay una razón para sonreír", points: ["Mickey Mouse": 2]),
            AnswerOption(title: "Mi valor no depende de lo que otros esperen", points: ["Mulan": 2]),
            AnswerOption(title: "Puedo aprender del pasado y elegir cómo seguir", points: ["Simba": 2]),
            AnswerOption(title: "El horizonte me invita a descubrir más", points: ["Moana": 2])
        ])
    ]

    @State private var currentQuestionIndex = 0
    @State private var selectedOptionIndex: Int? = nil
    @State private var scores: [String: Int] = [
        "Mickey Mouse": 0, "Mulan": 0, "Simba": 0, "Moana": 0
    ]
    @State private var result: CharacterResult? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.95), Color.cyan.opacity(0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if let result = result {
                resultView(result)
            } else {
                quizView
            }
        }
        .preferredColorScheme(.light)
    }

    private var quizView: some View {
        VStack(spacing: 20) {
            Text("¿QUÉ PERSONAJE DISNEY ERES?")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.top, 24)

            Text("Pregunta \(currentQuestionIndex + 1) de \(questions.count)")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.95))

            ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                .tint(.yellow)
                .padding(.horizontal, 8)

            Text(questions[currentQuestionIndex].text)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 90)

            VStack(spacing: 12) {
                ForEach(questions[currentQuestionIndex].options.indices, id: \.self) { index in
                    Button {
                        // Solo se permite seleccionar una opción en cada pregunta.
                        if selectedOptionIndex == nil {
                            selectedOptionIndex = index
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Text(questions[currentQuestionIndex].options[index].title)
                                .multilineTextAlignment(.leading)
                            Spacer(minLength: 4)
                            Image(systemName: selectedOptionIndex == index
                                  ? "checkmark.circle.fill" : "circle")
                        }
                        .font(.body.weight(.medium))
                        .foregroundStyle(selectedOptionIndex == index ? .white : .blue)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(selectedOptionIndex == index ? Color.green : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedOptionIndex != nil)
                }
            }

            Button(action: submitAnswer) {
                Text(currentQuestionIndex == questions.count - 1 ? "Ver mi personaje" : "Siguiente")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedOptionIndex == nil ? Color.white.opacity(0.55) : Color.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(selectedOptionIndex == nil)

            Spacer(minLength: 4)
        }
        .padding(24)
    }

    private func submitAnswer() {
        guard let selectedOptionIndex = selectedOptionIndex else { return }
        let chosenOption = questions[currentQuestionIndex].options[selectedOptionIndex]

        // Acumula los puntos con un diccionario y un ciclo for.
        for (character, points) in chosenOption.points {
            scores[character, default: 0] += points
        }

        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            self.selectedOptionIndex = nil
        } else {
            result = determineResult()
        }
    }

    private func determineResult() -> CharacterResult {
        var bestCharacter = "Mickey Mouse"
        var bestScore = -1

        // Recorre la colección para hallar la puntuación mayor.
        // En caso de empate, el primer resultado máximo encontrado se conserva.
        for (character, score) in scores {
            if score > bestScore {
                bestScore = score
                bestCharacter = character
            }
        }

        return characters[bestCharacter] ?? CharacterResult(
            name: "Personaje sorpresa",
            description: "Tus respuestas reflejan una combinación especial de cualidades.",
            emoji: "✨"
        )
    }

    private func resultView(_ character: CharacterResult) -> some View {
        VStack(spacing: 22) {
            Text("¡Tu personaje Disney es…!")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Text(character.emoji)
                .font(.system(size: 92))

            Text(character.name)
                .font(.system(size: 34, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.yellow)

            Text(character.description)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)

            Text("Resultado basado en tus cinco respuestas.")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
        }
        .padding(28)
    }
}

#Preview {
    ContentView()
}
