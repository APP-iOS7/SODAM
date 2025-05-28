import SwiftUI

struct EducationListView: View {
    
    @StateObject var educationListViewModel: EducationListViewModel
    var add: String = ""
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Divider()
                    ForEach(educationListViewModel.spots, id: \.self) { spot in
                        NavigationLink {
                            //TODO: DetailView 연결
                            DetailView(item: spot)
                        } label: {
                            EducationListCellView(spot: spot)
                        }
                        Divider()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct EducationListCellView: View {
    @Environment(\.colorScheme) var scheme
    var spot: DetailModel
    
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
                    Text(spot.title.replacingOccurrences(of: "(초등 교과연계)",
                                                         with: ""))
                        .foregroundStyle(Color.textColor)
                        .lineLimit(1)
                        .padding(.top, 2)
                    Text("\(spot.addr1 ?? "") \(spot.addr2 ?? "")" )
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundStyle(.gray)
                }
                .padding(.leading, 5)
                Spacer()
            }
            HStack(alignment: .center) {
                Text("\(String(format: "%02d", (Int(spot.playTime ?? "0") ?? 0) / 60)):\(String(format: "%02d", (Int(spot.playTime ?? "0") ?? 0 ) % 60))")
                Image(systemName: "play.circle")
            }
            .foregroundStyle(Color.textColor)
            .padding(.trailing, 5)
        }
        .padding([.leading, .trailing], 15)
    }
}

