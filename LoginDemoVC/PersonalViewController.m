//
//  PersonalViewController.m
//  app
//
//  Created by zhao on 2019/12/10.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "PersonalViewController.h"

#import "PersonalTableViewCell.h"
#import "ChangePassWordVC.h"
#import "ChangeUserNameVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BindPhoneViewController.h"
#import "CertificationViewController.h"
#import "EnterPriseCertificationVC.h"


@interface PersonalViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImage *selectImage;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  self.navigationItem.title = @"个人资料";
  self.view.frame = [[UIScreen mainScreen] bounds];
  
  self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.scrollEnabled = NO;
  self.tableView.separatorInset = UIEdgeInsetsZero;
  [self.view addSubview:self.tableView];
  
  self.tableView.tableFooterView = [[UIView alloc] init];
  [self.tableView reloadData];
  
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  
}

#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
  
  return 1;
  
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  return self.dataArr.count;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalTableViewCell"];
  
  if (cell == nil) {
    cell = [[NSBundle mainBundle] loadNibNamed:@"PersonalTableViewCell" owner:self options:nil].firstObject;
  }
  
  NSDictionary *item = self.dataArr[indexPath.row];
  
  cell.personalTitle.text = item[@"title"];
  cell.personalValue.text = item[@"value"];

  if ([item[@"type"] isEqualToString:@"header"]) {
    cell.headerImageView.hidden = NO;
    
    if (self.selectImage != nil) {
      cell.headerImageView.image = self.selectImage;
    }
  } else {
    cell.headerImageView.hidden = YES;
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  return cell;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 50.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *item = self.dataArr[indexPath.row];
  
  if (item[@"callBack"] != nil) {
    self.callblock(item);
  } else {
    
    switch ([item[@"tag"] integerValue]) {
      case 0: //头像
      {
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
        break;
      case 1: //用户名
      {
        ChangeUserNameVC *changeVC = [[ChangeUserNameVC alloc] init];
        changeVC.token = self.token;
        changeVC.urlDic = self.urlDic;
        [changeVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:changeVC animated:YES];
      }
        break;
      case 2://手机号
      {
        if ([item[@"value"] isEqualToString:@"去绑定"]) {
          BindPhoneViewController *bindVC = [[BindPhoneViewController alloc] init];
          bindVC.token = self.token;
          bindVC.urlDic = self.urlDic;
          [bindVC setHidesBottomBarWhenPushed:YES];
          [self.navigationController pushViewController:bindVC animated:YES];
        }
      }
        break;
      case 3://登录密码
      {
        ChangePassWordVC *changePwVC = [[ChangePassWordVC alloc] init];
        changePwVC.token = self.token;
        changePwVC.urlDic = self.urlDic;
        [changePwVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:changePwVC animated:YES];
      }
        
        break;
      case 4://实名认证
      {
        CertificationViewController *certVC = [[CertificationViewController alloc] init];
        [certVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:certVC animated:YES];
      
      }
        break;
      case 5://企业认证
      {
        EnterPriseCertificationVC *epCertVC = [[EnterPriseCertificationVC alloc] init];
        [epCertVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:epCertVC animated:YES];
        
      }
        break;
        
      default:
        break;
    }
    
    
  }
  
}




#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  
  //得到的图片
  self.selectImage = info[UIImagePickerControllerOriginalImage];
  [self.tableView reloadData];
  
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
