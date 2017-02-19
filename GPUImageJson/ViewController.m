//
//  ViewController.m
//  GPUImageJson
//
//  Created by sakiyamaK on 2017/02/19.
//
//

#import "ViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageFilterDictionary.h"


#define CAMERA_W 1280.0
#define CAMERA_H 720.0
#define CAMERA_P AVCaptureSessionPreset1280x720

@interface ViewController ()
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *previewView;
@property (nonatomic, strong) GPUImageFilterDictionary *filterDic;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupCamera];
  [self setupLayout];
  [self setupFilter];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
  if(_videoCamera)[_videoCamera startCameraCapture];
}

-(void)viewWillDisappear:(BOOL)animated{
  if(_videoCamera) [_videoCamera stopCameraCapture];
}

#pragma mark - layout

-(void)setupCamera{
  
  GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:CAMERA_P
                                                                         cameraPosition:AVCaptureDevicePositionBack
                                      ];
  videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
  videoCamera.horizontallyMirrorFrontFacingCamera = YES;
  videoCamera.horizontallyMirrorRearFacingCamera = NO;
  self.videoCamera = videoCamera;
  
}

-(void)setupLayout{
  self.view.frame = UIScreen.mainScreen.bounds;
  GPUImageView *gpuImageView = GPUImageView.new;
  gpuImageView.frame = self.view.frame;
  gpuImageView.contentMode = UIViewContentModeScaleAspectFit;
  gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatio;
  [self.view addSubview:gpuImageView];
  _previewView = gpuImageView;}

-(void)setupFilter{
  
  if(!_videoCamera) return;
  
  [_videoCamera removeAllTargets];
  
  GPUImageFilterDictionary *filterDic = [[GPUImageFilterDictionary alloc] initWithJsonFilePath:@"sample_filter"];
  _filterDic = filterDic;
  
  GPUImageFilter *createFilter = (GPUImageFilter *)filterDic.gpuImage;
  
  [_videoCamera addTarget:createFilter];
  [createFilter addTarget:_previewView];
}


@end
