

#import "PDLiteAboutTableViewController.h"
#import <MessageUI/MessageUI.h>
#import "SDiOSVersion.h"
#import "AppHelper.h"

@interface PDLiteAboutTableViewController ()
<MFMailComposeViewControllerDelegate>

@property(nonatomic, strong, readwrite) NSArray<NSString*>* aboutSections;

@property(nonatomic, strong, readwrite) NSDictionary<NSString*, NSArray<NSString*>*>* aboutRows;

@property(nonatomic, assign, readwrite) double iphoneTotalCapacity;

@property(nonatomic, assign, readwrite) double iphoneRemainCapacity;

@property(nonatomic, assign, readwrite) double powerDriveRemainCapacity;

@property(nonatomic, assign, readwrite) double powerDriveTotalCapacity;

@end

@implementation PDLiteAboutTableViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.title = NSLocalizedString(@"Setting", nil);
    
    self.aboutSections = @[NSLocalizedString(@"Capacity", nil), NSLocalizedString(@"App", nil)];

    self.aboutRows = @{NSLocalizedString(@"Capacity", nil):@[NSLocalizedString(@"iPhone", nil)],
                       NSLocalizedString(@"App", nil):@[NSLocalizedString(@"Feedback", nil)]};

    [self getFreeDiskspace];
    
  
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Done", nil)
                                                                              style: UIBarButtonItemStylePlain
                                                                             target: self
                                                                             action: @selector(dismiss)];
}


- (void) dismiss {

    [self dismissViewControllerAnimated: YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.aboutSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.aboutRows[self.aboutSections[section]].count;
}


- (NSString*) tableView: (UITableView*) tableView titleForHeaderInSection:(NSInteger)section {

    return self.aboutSections[section];
}


static NSString* reusableCellId = @"reusableCellId";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reusableCellId];

    if (cell == nil) {

        cell =  [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: reusableCellId];
    }

    NSString* rowName = self.aboutRows[self.aboutSections[indexPath.section]][indexPath.row];

    cell.textLabel.text = rowName;

    cell.userInteractionEnabled = NO;

    if ([rowName isEqualToString: NSLocalizedString(@"Feedback", nil)]
        || [rowName isEqualToString: NSLocalizedString(@"Device Information", nil)]) {

        [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];

        cell.userInteractionEnabled = YES;
    }

    if ([rowName isEqualToString: NSLocalizedString(@"iPhone", nil)]) {

        //Remain/Total:
        cell.detailTextLabel.text
            = [NSString stringWithFormat:NSLocalizedString(@"%0.2fG / %0.2fG", nil),
                                        self.iphoneRemainCapacity / 1024.0 ,
                                        self.iphoneTotalCapacity/1024.0];
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString* rowName = self.aboutRows[self.aboutSections[indexPath.section]][indexPath.row];

    if ([rowName isEqualToString: NSLocalizedString(@"Feedback", nil)] ) {
        
        NSString* appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];


        NSArray<NSString*>* specName = @[
                                        NSLocalizedString(@"App Version", nil),
                                        NSLocalizedString(@"Device Type", nil),
                                        NSLocalizedString(@"System Name", nil)
                                        ];

        NSString* content = [NSString stringWithFormat:@"<br/><br/><br/>%@: %@<br/> %@: %@<br/> %@: %@<br/>",
                             specName[0], appVersion,
                             specName[1], [SDiOSVersion deviceVersionName],
                             specName[2], [SDiOSVersion systemName]
         ];
        

        [self sendEmailToEmailAddress: NSLocalizedString(@"pixxf@me.com",nil)
                          withSubject: NSLocalizedString(@"Feedback of CryptoKeyboard to Developer", nil)
                           andContent:content];

    }
}

#pragma mark - Send Email

- (BOOL) haveEmailAccount {

    return [MFMailComposeViewController canSendMail];;
}

- (void) sendEmailToEmailAddress: (NSString*) emailAddress withSubject: (NSString*) subjectStr andContent: (NSString*) content {

    if ([self haveEmailAccount]) {

        [self sendEmailWithIntegratedControllerToEmailAddress:emailAddress withSubject:subjectStr andContent: content];

    } else {

        [self sendEmailWithiOSNativeEmailAppToEmailAddress: emailAddress withSubject: subjectStr andContent: content];
    }
}

//@"Feedback to PowerDrive team"

- (void) sendEmailWithiOSNativeEmailAppToEmailAddress: (NSString*) emailAddress
                                          withSubject: (NSString*) subjectStr
                                           andContent: (NSString*) content {

    // send email.
    /* create mail subject */
    NSString *subject = [NSString stringWithFormat:NSLocalizedString(subjectStr, @"title")];

    /* define email address */
    NSString *mail = emailAddress;

    /* define allowed character set */
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];

    /* create the URL */
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
                                                [mail stringByAddingPercentEncodingWithAllowedCharacters: set],
                                                [subject stringByAddingPercentEncodingWithAllowedCharacters: set],
                                                [content stringByAddingPercentEncodingWithAllowedCharacters: set]
                                                ]
                  ];

    /* load the URL */
    [[UIApplication sharedApplication] openURL:url];

}

- (void) sendEmailWithIntegratedControllerToEmailAddress: (NSString*) emailAddress
                                             withSubject: (NSString*) subjectStr
                                              andContent: (NSString*) content {

    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];

    mailPicker.mailComposeDelegate = self;
    //设置主题
    [mailPicker setSubject: NSLocalizedString(subjectStr, @"title")];
    //添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject:emailAddress];

    [mailPicker setToRecipients: toRecipients];

    NSString *emailBody = content;

    [mailPicker setMessageBody:emailBody isHTML: YES];

    [self presentViewController:mailPicker animated:YES completion:^{

    }];

}

- (void)mailComposeController: (MFMailComposeViewController *)controller
          didFinishWithResult: (MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;

    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = NSLocalizedString(@"Email Cancelled", @"message");//"邮件发送取消"
            break;
        case MFMailComposeResultSaved:
            msg = NSLocalizedString(@"Email saved", @"message");//@"邮件保存成功"

            break;
        case MFMailComposeResultSent:
            msg = NSLocalizedString(@"Email sent", @"message");//@"邮件发送成功"

            break;
        case MFMailComposeResultFailed:
            msg = NSLocalizedString(@"Email Failed", @"message");//@"邮件发送失败"

            break;
        default:
            msg = NSLocalizedString(@"Email not sent", @"message");//@"邮件未发送"
            break;
    }

    NSLog(@"msg = %@",msg);

    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void) getFreeDiskspace {
    
    int64_t totalSpaceSizeOfIphone = 0;
    int64_t freeSpaceSizeOfIphone = 0;
    
    [AppHelper getiDeviceTotalSpace: &totalSpaceSizeOfIphone andFreeSpace: &freeSpaceSizeOfIphone];
    
    if (totalSpaceSizeOfIphone > 0) {
        
        self.iphoneTotalCapacity = totalSpaceSizeOfIphone / 1024.0 / 1024.0;
        
        self.iphoneRemainCapacity = freeSpaceSizeOfIphone / 1024.0 / 1024.0;
    }
}

@end


















