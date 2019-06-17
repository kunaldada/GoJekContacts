Go Jek Contacts

Modals:

I created 2 modals for this app - ShortContactModal and ContactModal (the detailed version with email, phone number) 

Views:

1. ContactListViewController - Home Listing Contacts page. Driven by its view modal "ContactListViewModalProtocol". The table view contains ContactListTableViewCell driven by ContactListCellViewModal.

2. ContactDetailViewController - Contact Detail Page with its business logic embedded in ContactDetailViewModal. The table view contains ContactDetailProfileTableViewCell and ContactDetailInfoTableViewCell both driven by ContactDetailCellViewModalProtocol.

3. AddEditContactViewController - For adding a new contact/ editing an existing one. Its business logic is embedded in AddEditContactViewModal. The table view contains EditContactProfileTableViewCell and EditContactOtherInfoTableViewCell both driven by AddEditContactCellViewModalProtocol.  


Unit Test Cases:

1. To Test contacts grouping logic on home page
2. To Test edit contact api interaction flow using mocks.
3. To Test add contact api interaction flow using mocks.
4. To Test favorite status change reflection from detail page to home listing page.
5. To Test edited contact reflection from edit page to detail page and home listing page.


Third Party Frameworks used:

1. Alamofire - Alamofire was used for both data and image fetching.
2. SVProgressHud - Used for showing progress.
