import UIKit

class Account {
    let name: String
    weak var creditCard: CreditCard?
    
    init(name: String, creditCard: CreditCard) {
        self.name = name
        self.creditCard = creditCard
    }
    
    deinit {
        print("account was deinit")
    }
}


class CreditCard {
    let number: Int
    init(number: Int) {
        self.number = number
    }
    
    deinit {
        print("creditCard was deinit")
    }
}


var credit: CreditCard? = CreditCard(number: 135423452345)
var account: Account? = Account(name: "Ricardo", creditCard: credit!)

credit = nil

print(account?.creditCard?.number)
