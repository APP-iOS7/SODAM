import SwiftUI

struct EducationListView: View {
    
    var category: String
    @StateObject var educationListViewModel = EducationListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(educationListViewModel.spots, id: \.self) { spot in
                    NavigationLink {
                        //TODO: DetailView 연결
                        DetailView(item: spot)
                    } label: {
                        EducationListCellView(spot: spot)
                    }
                }
                Spacer()
            }
        }
    }
}

struct EducationListCellView: View {
    @Environment(\.colorScheme) var scheme
    let spot: DetailModel
    var body: some View {
        HStack {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: spot.imageUrl ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 70, height: 70)
                .cornerRadius(10)
                VStack(alignment: .leading) {
                    Text(spot.title)
                        .foregroundStyle(scheme == .light ? Color.black : Color.white)
                    Text(spot.addr1 ?? "" )
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding(.leading, 5)
                Spacer()
            }
            HStack(alignment: .center) {
                Text("\(String(format: "%02d", (Int(spot.playTime ?? 0) ?? 0) / 60)):\(String(format: "%02d", Int(spot.playTime ?? 0) ?? 0 % 60))")
                Image(systemName: "play.circle")
            }
            .foregroundStyle(scheme == .light ? Color.black : Color.white)
            .padding(.trailing, 30)
        }
        .padding([.leading, .trailing], 5)
    }
}

