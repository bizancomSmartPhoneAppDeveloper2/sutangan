//
//  ViewController.m
//  feel so good
//
//  Created by ビザンコムマック０５ on 2014/10/14.
//  Copyright (c) 2014年 bizan kunren2. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property AVAudioPlayer *mySound;
@end


@implementation ViewController {
    BOOL isVibe;
    BOOL isFlash;
    NSTimer *myTimer;
    NSTimer *superTimer;
//    @synthesize selector;//toggleBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 近接センサをONに
    
    // 近接センサをオン
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    // 近接センサ監視
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(proximitySensorStateDidchange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 近接センサの値が変更
- (void)proximitySensorStateDidchange:(NSNotification *)notification {
    
    if (isVibe == NO)
    {
        isVibe = YES;
        [self soundnarasu];
        [self timerVibe];
        [self timerFlash];
//        NSLog(@"上とまった %d", isVibe);
    }
    else
    {
        //止まるメソッド
        isVibe = NO;
        [myTimer invalidate];
        [superTimer invalidate];
//        NSLog(@"中とまった %d", isVibe);
    }
}


//タイマーの動き
-(void)timerVibe{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                               target:self
                                             selector:@selector(vibe)
                                             userInfo:nil
                                              repeats:YES];
}

-(void)timerFlash{
    superTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                               target:self
                                             selector:@selector(flashOnOff)
                                             userInfo:nil
                                              repeats:YES];
}



- (void)stopSensor {
    // 近接センサオフ
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    // 近接センサ監視解除
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification                                                  object:nil];
}

//バイブレーションを動かす
-(void)vibe
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)soundnarasu{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sutan.saidai" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.mySound = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];
    [self.mySound play];
}


//ライトがつくメソッド
- (void)torchOnFunction
{
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if(success)
        {
            [flashLight setTorchMode:AVCaptureTorchModeOn];
            [flashLight unlockForConfiguration];
        }
    }
}

//ライトが消えるメソッド
- (void)torchOffFunction
{
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOff])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if(success)
        {
            [flashLight setTorchMode:AVCaptureTorchModeOff];
            [flashLight unlockForConfiguration];
        }
    }
}

//
-(void)flashOnOff{
    if(isFlash == YES) { //ライトがついていたら
        [self torchOffFunction];
        isFlash = NO;
    }else{
        [self torchOnFunction];
        isFlash =YES;
    }
}


@end
