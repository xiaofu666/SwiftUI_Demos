//
//  MapBottomSheetView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/13.
//

import SwiftUI
import MapKit

@available(iOS 16.0, *)
struct MapBottomSheetView: View {
    @State private var showAnotherSheet: Bool = false
    private var albumData = AlbumData()
    var body: some View {
        ZStack {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708), latitudinalMeters: 10000, longitudinalMeters: 10000)
            Map(coordinateRegion: .constant(region))
                .ignoresSafeArea()
                .overlay(alignment: .topTrailing, content: {
                    Button {
                        showAnotherSheet.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                    }
                    .padding()

                })
                .bottomSheet(presentationDetents: [.medium, .large, .height(70)], isPresented: .constant(true), sheetCornerRadius: 20, isTransparentBG: true) {
                    VStack(spacing: 15) {
                        TextField("Search Maps", text: .constant(""))
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            }
                            .zIndex(1)
                        
                        //songs list
                        ScrollView(.vertical, showsIndicators: false) {
                            albumData.SongsList()
                                .zIndex(0)
                        }
                        .ignoresSafeArea()
                    }
                    .padding()
                    .padding(.top)
                    .background(content: {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                    })
                    .sheet(isPresented: $showAnotherSheet) {
                        BottomSheetNewView()
                    }
                    .ignoresSafeArea()
                } onDismiss: {
                    
                }

        }
    }
    
}

@available(iOS 16.0, *)
struct MapBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapBottomSheetView()
    }
}

@available(iOS 16.0, *)
extension View {
    @ViewBuilder
    func bottomSheet<Content: View>(
        presentationDetents: Set<PresentationDetent>,
        isPresented: Binding<Bool>,
        dragIndicator: Visibility = .visible,
        sheetCornerRadius: CGFloat?,
        largestUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
        isTransparentBG: Bool = false,
        interactiveDisabled: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: @escaping () -> ()
    ) -> some View {
        self
            .sheet(isPresented: isPresented, onDismiss: {
                onDismiss()
            }, content: {
                content()
                    .presentationDetents(presentationDetents)
                    .presentationDragIndicator(dragIndicator)
                    .interactiveDismissDisabled(interactiveDisabled)
                    .onAppear {
                        // MARK: Custom Code For Bottom Sheet
                        guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                            print("Not Fount WindowScens")
                            return
                        }
                        guard let controller = windows.windows.first?.rootViewController?.presentedViewController, let sheet = controller.presentationController as? UISheetPresentationController else {
                            print("Not Fount Controller")
                            return
                        }
                        if isTransparentBG {
                            controller.presentingViewController?.view.backgroundColor = .clear
                        }
                        controller.presentingViewController?.view.tintAdjustmentMode = .normal
                        sheet.largestUndimmedDetentIdentifier = largestUndimmedIdentifier
                        sheet.preferredCornerRadius = sheetCornerRadius
                    }
            })
    }
}
