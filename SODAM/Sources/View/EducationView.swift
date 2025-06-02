import SwiftUI

struct EducationView: View {
    @StateObject var edcationViewModel = EducationViewModel()
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                VStack {
                    ForEach(edcationViewModel.educations) { education in
                        NavigationLink {
                            EducationListView(educationListViewModel: EducationListViewModel(spots: education.lists))
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: geo.size.height / 4.3)
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
}

#Preview {
    EducationView()
}


