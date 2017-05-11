//
//  LocationType.swift
//  Health Care Near Me
//
//  Created by Rudy Bermudez on 4/30/17.
//  Copyright © 2017 Rudy Bermudez. All rights reserved.
//

import Foundation

enum MedicalLocation: Int {
    case acupuncturist = 0
    case alternativeHealer
    case chiropractor
    case dentistOffice
    case doctorsOffice
    case emergencyRoom
    case eyeDoctor
    case hospital
    case hospitalWard
    case maternityClinic
    case medicalCenter
    case medicalLab
    case mentalHealthOffice
    case nutritionist
    case physicalTherapist
    case rehabCenter
    case urgentCareCenter
    
    func toFourSquareID() -> String {
        switch self {
        case .medicalCenter: return "4bf58dd8d48988d104941735"
        case .acupuncturist: return "52e81612bcbc57f1066b7a3b"
        case .alternativeHealer: return "52e81612bcbc57f1066b7a3c"
        case .chiropractor: return "52e81612bcbc57f1066b7a3a"
        case .dentistOffice: return "4bf58dd8d48988d178941735"
        case .doctorsOffice: return "4bf58dd8d48988d177941735"
        case .emergencyRoom: return "4bf58dd8d48988d194941735"
        case .eyeDoctor: return "522e32fae4b09b556e370f19"
        case .hospital: return "4bf58dd8d48988d196941735"
        case .hospitalWard: return "58daa1558bbb0b01f18ec1f7"
        case .maternityClinic: return "56aa371be4b08b9a8d5734ff"
        case .medicalLab: return "4f4531b14b9074f6e4fb0103"
        case .mentalHealthOffice: return "52e81612bcbc57f1066b7a39"
        case .nutritionist: return "58daa1558bbb0b01f18ec1d0"
        case .physicalTherapist: return "5744ccdfe4b0c0459246b4af"
        case .rehabCenter: return "56aa371be4b08b9a8d57351d"
        case .urgentCareCenter: return "56aa371be4b08b9a8d573526"
        }
    }
}

extension MedicalLocation: CustomStringConvertible {
    var description: String {
        switch self {
        case .acupuncturist: return "Acupuncturist"
        case .alternativeHealer: return "Alternative Healer"
        case .chiropractor: return "Chiropractor"
        case .dentistOffice: return "Dentist's Office"
        case .doctorsOffice: return "Doctor's Office"
        case .emergencyRoom: return "Emergency Room"
        case .eyeDoctor: return "Eye Doctor"
        case .hospital: return "Hospital"
        case .hospitalWard: return "Hospital Ward"
        case .maternityClinic: return "Maternity Clinic"
        case .medicalCenter: return "Medical Center"
        case .medicalLab: return "Medical Lab"
        case .mentalHealthOffice: return "Mental Health Office"
        case .nutritionist: return "Nutritionist"
        case .physicalTherapist: return "Physical Therapist"
        case .rehabCenter: return "Rehab Center"
        case .urgentCareCenter: return "Urgent Care Center"
        }
    }
}


/// IterateEnum
///
/// - Parameter _ : Any Enum that you would like to iterate over
/// - Author: [Rintaro](http://stackoverflow.com/a/28341290)
/// - Returns: A generic Iterator of the paramaterized enum
func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}
