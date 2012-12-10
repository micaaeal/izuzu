//
//  GamePlayViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/6/55 BE.
//
//

#import "GamePlayViewController.h"
#import "PlayDriftLayer.h"

@interface GamePlayViewController ()

@end

@implementation GamePlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set button highlighted state
    [_btnPause setImage:[UIImage imageNamed:@"pauseButton02.png"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [_pauseMenuViewController release];
    [_btnPause release];
    [_restartMenuViewController release];
    [_winMenuViewController release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPauseMenuViewController:nil];
    [self setBtnPause:nil];
    [self setRestartMenuViewController:nil];
    [self setWinMenuViewController:nil];
    [super viewDidUnload];
}
- (IBAction)onPause:(id)sender {
    
    [self.view addSubview:_pauseMenuViewController.view];
    [self.view bringSubviewToFront:_pauseMenuViewController.view];
    _pauseMenuViewController.delegate   = self;
    
    [[CCDirector sharedDirector] pause];
    
}

- (IBAction) onWin: (id) sender
{
    [self.view addSubview:_winMenuViewController.view];
    [_winMenuViewController initDataByHand:self isWin:YES];
    _winMenuViewController.delegate = self;
    
    [[CCDirector sharedDirector] pause];
}
- (IBAction) onLost: (id) sender
{
    [self.view addSubview:_winMenuViewController.view];
    [_winMenuViewController initDataByHand:self isWin:NO];
    _winMenuViewController.delegate = self;
    
    [[CCDirector sharedDirector] pause];
}

#pragma mark - PauseMenuViewDelegate + RestartMenuViewDelegate

- (void) onResume: (id) sender
{
    if ( sender == _pauseMenuViewController )
    {
        [_pauseMenuViewController.view removeFromSuperview];
        
        [[CCDirector sharedDirector] resume];
    }
    else if ( sender == _restartMenuViewController )
    {
        [_restartMenuViewController.view removeFromSuperview];
        
        [self.view addSubview:_pauseMenuViewController.view];
        [self.view bringSubviewToFront:_pauseMenuViewController.view];
        _pauseMenuViewController.delegate   = self;
    }
}

#pragma mark - PauseMenuViewDelegate

- (void) onRetry: (id) sender
{
    [_pauseMenuViewController.view removeFromSuperview];
    
    [self.view addSubview:_restartMenuViewController.view];
    [self.view bringSubviewToFront:_restartMenuViewController.view];
    _restartMenuViewController.delegate   = self;
    
    if ( _playDriftLayer.currentState   == _playDriftLayer.stateDriveCar )
    {
        [_restartMenuViewController.btnRestart setEnabled:YES];
    }
    else
    {
        [_restartMenuViewController.btnRestart setEnabled:NO];
    }
}
- (void) onExit: (id) sender
{
    if ( _playDriftLayer )
    {
        [[CCDirector sharedDirector] resume];
        [_playDriftLayer onBackToMenu:self];
    }
}

#pragma mark - RestartMenuViewDelegate & WinMenuViewDelegate

- (void) onRestart: (id) sender
{
    if ( sender == _restartMenuViewController )
    {
        [_restartMenuViewController.view removeFromSuperview];
    }
    else if ( sender == _winMenuViewController )
    {
        [_winMenuViewController.view removeFromSuperview];
        [self onNewPath:self];
        return;
    }
    
    if ( _playDriftLayer )
    {
        if ( _playDriftLayer.currentState == _playDriftLayer.stateDriveCar )
        {
            [[CCDirector sharedDirector] resume];
            [_playDriftLayer.currentState onRestart];
        }
    }
}

#pragma mark - RestartMenuViewDelegate

- (void) onNewPath: (id) sender
{
    [_restartMenuViewController.view removeFromSuperview];
    
    if ( _playDriftLayer )
    {
        [[CCDirector sharedDirector] resume];
        [_playDriftLayer onRestart:self];
    }
}

#pragma mark - WinMenuViewDelegate

- (void) onNext:(id)sender
{
    
}

- (void) onShare:(id)sender
{
    
}

@end
