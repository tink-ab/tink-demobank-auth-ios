import SwiftUI

struct HeaderView: View {

    let color: Color
    let text: String
    
    var body: some View {
        ZStack {
            BackgroundShape().foregroundColor(color).edgesIgnoringSafeArea(.all)
            VStack(spacing: 22) {
                Spacer()
                TinkDemoLogo().frame(width: 80, height: 80)
                Text("Tink Demo Bank")
                    .bold()
                    .font(.system(size: 21))
                    .foregroundColor(Color.buttonLabel)
                Text(text)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.buttonLabel)
                    .padding([.trailing, .leading], 20)
                    .frame(minHeight: 130, alignment: .top)
                Spacer()
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HeaderView(color: .button, text: "TEST")

            HeaderView(color: .button, text: "A longer text.\n\nThis one have multiple lines even.\n\n Amazing.")
        }
    }
}
