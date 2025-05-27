import SwiftUI

struct EducationView: View {
    @StateObject var edcationViewModel = EducationViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(edcationViewModel.educations) { education in
                    NavigationLink {
                        EducationListView(educationListViewModel: EducationListViewModel(spots: education.lists))
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 150)
                            .padding([.leading, .trailing], 5)
                            .foregroundStyle(education.color)
                            .overlay(
                                ZStack {
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                            Text("\(education.name)")
                                                .font(.title)
                                                .foregroundStyle(Color.textColor)
                                        }
                                        .padding(10)
                                    }
                                    .padding(10)
                                }
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    EducationView()
}


