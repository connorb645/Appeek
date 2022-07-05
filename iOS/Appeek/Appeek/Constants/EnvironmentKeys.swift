//
//  EnvironmentKeys.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation

enum EnvironmentKey {
    case supabaseBaseUrl, supabaseKey
    var value: String {
        switch self {
        case .supabaseBaseUrl:
            return "byqntspqshyepqwmsxwc.supabase.co"
        case .supabaseKey:
            return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ5cW50c3Bxc2h5ZXBxd21zeHdjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTYyNzc1NTMsImV4cCI6MTk3MTg1MzU1M30.hrzjOL9jqgsw8JMJ8CckQsmPq5lHhHRwGfmtDHN9jlQ"
        }
    }
}
