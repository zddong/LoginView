//
//  EnterPriseCertificationVC.m
//  app
//
//  Created by zhao on 2019/12/12.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EnterPriseCertificationVC.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface EnterPriseCertificationVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *epName;
@property (weak, nonatomic) IBOutlet UITextField *taxpayerNumber;
@property (weak, nonatomic) IBOutlet UITextField *legalName;
@property (weak, nonatomic) IBOutlet UITextField *legalPhone;
@property (weak, nonatomic) IBOutlet UITextField *epmail;


@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *licenseImageView;


@property (nonatomic, assign) NSInteger tag; //区分是正面还是反面 0正面 1反面 2营业执照

@end

@implementation EnterPriseCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  self.navigationItem.title = @"企业认证";
  self.view.frame = [[UIScreen mainScreen] bounds];
  
  self.frontImageView.contentMode = UIViewContentModeScaleAspectFill;
  self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
  self.licenseImageView.contentMode = UIViewContentModeScaleAspectFill;
  
    // Do any additional setup after loading the view from its nib.
}

//选择图片
- (IBAction)SelectPictureClick:(UIButton *)sender {
  
  self.tag = sender.tag-100;
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    imagePicker.title  = @"拍照";
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
    [self presentViewController:imagePicker animated:YES completion:nil];
  }];
  UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    imagePicker.title  = @"选择照片";
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
    [self presentViewController:imagePicker animated:YES completion:nil];
  }];
  UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
  
  [alertController addAction:actionA];
  [alertController addAction:actionB];
  [alertController addAction:actionCancle];
  
  [self presentViewController:alertController animated:YES completion:nil];
  
}


//提交认证
- (IBAction)SubmitCertification:(UIButton *)sender {
    
    
}



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  
  //得到的图片
  UIImage *image = info[UIImagePickerControllerOriginalImage];
  
  if (self.tag == 0) {
    
    self.frontImageView.image = image;
    
  }else if (self.tag == 1){
    
    self.backImageView.image = image;
    
  }else if (self.tag == 2){
    
    self.licenseImageView.image = image;
    
  }
 
  
  [picker dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
