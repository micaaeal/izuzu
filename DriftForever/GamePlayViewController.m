//
//  GamePlayViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/6/55 BE.
//
//

#import "GamePlayViewController.h"
#import "PlayDriftLayer.h"
#import "Mission.h"

@interface GamePlayViewController ()

- (void) _showSelectRouteUI;
- (void) _showDrivingCarUI;
- (void) _hideAllMenu;

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
    
    // UI.
    [_btnDrawPath setImage:[UIImage imageNamed:@"drawPathButton02.png"] forState:UIControlStateHighlighted];
    [_btnErasePath setImage:[UIImage imageNamed:@"erasePathButton02.png"] forState:UIControlStateHighlighted];
    [_btnBack setImage:[UIImage imageNamed:@"backButton02.png"] forState:UIControlStateHighlighted];
    [_btnOK setImage:[UIImage imageNamed:@"okButton02.png"] forState:UIControlStateHighlighted];
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
    [_btnOK release];
    [_btnBack release];
    [_btnErasePath release];
    [_btnDrawPath release];
    [_btnZoomIn release];
    [_btnZoomOut release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPauseMenuViewController:nil];
    [self setBtnPause:nil];
    [self setRestartMenuViewController:nil];
    [self setWinMenuViewController:nil];
    [self setBtnOK:nil];
    [self setBtnBack:nil];
    [self setBtnErasePath:nil];
    [self setBtnDrawPath:nil];
    [self setBtnZoomIn:nil];
    [self setBtnZoomOut:nil];
    [super viewDidUnload];
}

- (void) initDataByHand: (id) sender
{
    [self _showSelectRouteUI];
    [self _hideAllMenu];
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

- (IBAction)onOk:(id)sender {
    
    [self _showDrivingCarUI];
    
    if ( _delegate )
    {
        [_delegate onGoDrive:self];
    }
}

- (IBAction)onBack:(id)sender {
    if ( _delegate )
    {
        [_delegate onBack:self];
    }
}

- (IBAction)onErase:(id)sender {
    if ( _delegate )
    {
        [_delegate onErase:self];
    }
}

- (IBAction)onDraw:(id)sender {
    if ( _delegate )
    {
        [_delegate onDraw:self];
    }
}

- (IBAction)onZoomIn:(id)sender {
    if (_delegate)
    {
        [_delegate onZoomIn:self];
    }
}

- (IBAction)onZoomOut:(id)sender {
    if ( _delegate )
    {
        [_delegate onZoomOut:self];
    }
}

- (void) onReadyToDrive: (id) sender
{
    [_btnOK setEnabled:YES];
}
- (void) onPathNotFinishYet: (id) sender
{
    [_btnOK setEnabled:NO];
}

- (void) bringUIViewToFront
{
    [self.view bringSubviewToFront:_btnPause];
    [self.view bringSubviewToFront:_btnOK];
    [self.view bringSubviewToFront:_btnBack];
    [self.view bringSubviewToFront:_btnErasePath];
    [self.view bringSubviewToFront:_btnDrawPath];
    [self.view bringSubviewToFront:_btnZoomIn];
    [self.view bringSubviewToFront:_btnZoomOut];
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
            [self _showDrivingCarUI];
            [[CCDirector sharedDirector] resume];
            [_playDriftLayer.currentState onRestart];
        }
        else
        {
            [self _showSelectRouteUI];
            
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
    int cMissionCode    = [[Mission getObject] getCurrentMissionCode];
    int missionCount    = [[Mission getObject] getMissionCount];
    
    if ( cMissionCode < (missionCount-1) )
    {
        ++cMissionCode;
        [[Mission getObject] setCurrentMissionCode:cMissionCode];
        
        if ( _playDriftLayer )
        {
            [[CCDirector sharedDirector] resume];
            [_playDriftLayer onRestart:self];
        }
    }
}

- (void) onShare:(id)sender
{
    
}

#pragma mark - PIMPL

- (void) _showSelectRouteUI
{
    [_btnBack setHidden:NO];
    [_btnOK setHidden:NO];
    [_btnOK setEnabled:NO];
    [_btnDrawPath setHidden:NO];
    [_btnErasePath setHidden:NO];
    [_btnZoomIn setHidden:NO];
    [_btnZoomOut setHidden:NO];
    
    [_btnPause setHidden:NO];
}

- (void) _showDrivingCarUI
{
    [_btnBack setHidden:YES];
    [_btnOK setHidden:YES];
    [_btnOK setEnabled:NO];
    [_btnDrawPath setHidden:YES];
    [_btnErasePath setHidden:YES];
    [_btnZoomIn setHidden:YES];
    [_btnZoomOut setHidden:YES];
    
    [_btnPause setHidden:NO];
}

- (void) _hideAllMenu
{
    [_pauseMenuViewController.view removeFromSuperview];
    [_restartMenuViewController.view removeFromSuperview];
    [_winMenuViewController.view removeFromSuperview];
}

@end
