//
//  MUCellLb3WithFullWidhtLb1.m
//  TimeLink
//
//  Created by Yuriy Bosov on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MUCellLb3WithFullWidthLb1.h"

@implementation MUCellLb3WithFullWidthLb1Data

//==============================================================================
- (Class) getCellClass
{
    return [MUCellLb3WithFullWidthLb1 class];
}

//==============================================================================
- (float) heightCell
{
    float height = 0;
    float leftHeight = 0;
    float rightHeight = 0;
    
    CGSize textSize;
    
    if (leftText1)
    {
        textSize = [self sizeLabelWithText: leftText1 font:leftTextFont1 maxWidht:[self maxWidhtContentForHalfType:halfCellTypeLeft]];
        leftHeight = textSize.height;
    }
    if (leftText2) 
    {
        textSize = [self sizeLabelWithText: leftText2 font:leftTextFont2 maxWidht:[self maxWidhtContentForHalfType:halfCellTypeLeft]];
        leftHeight += distanceBetweenSubView + textSize.height;
    }
    if (leftText3) 
    {
        textSize = [self sizeLabelWithText: leftText3 font:leftTextFont3 maxWidht:[self widhtCellByOrientation] - paddingLeftHalf.leftPadding - paddingRightHalf.rightPadding];
        leftHeight += distanceBetweenSubView + textSize.height;
    }
    leftHeight += paddingLeftHalf.topPadding + paddingLeftHalf.bottomPadding;
    
    if (rightText1)
    {
        textSize = [self sizeLabelWithText:rightText1 font:rightTextFont1 maxWidht:[self maxWidhtContentForHalfType:halfCellTypeRight]];
        rightHeight = textSize.height + paddingRightHalf.topPadding + paddingRightHalf.bottomPadding;
    }
    
    height = MAX(leftHeight, rightHeight);
    height = MAX(height, 44);
    
    return height;
}

//==============================================================================
//==============================================================================
//==============================================================================
@end

//==============================================================================
//==============================================================================
//==============================================================================
@implementation MUCellLb3WithFullWidthLb1

//==============================================================================

- (void) createLeftContentView
{
    [super createLeftContentView];
    
    MUCellLb3WithFullWidthLb1Data* aCellData = (MUCellLb3WithFullWidthLb1Data*)cellData;

    CGSize labelSize = [cellData sizeLabelWithText:aCellData.leftText3
                                       font:aCellData.leftTextFont3
                                   maxWidht:[cellData widhtCellByOrientation] - cellData.paddingLeftHalf.leftPadding - cellData.paddingRightHalf.rightPadding];
    
    CGRect frame = CGRectMake(cellData.paddingLeftHalf.leftPadding,
                       leftLabel2.frame.origin.y + leftLabel2.frame.size.height + cellData.distanceBetweenSubView,
                       labelSize.width,
                       labelSize.height);
    
    leftLabel3.frame = frame;    
}

//==============================================================================
- (MUHalfCellAlignment) alignmentForHalfCellType:(MUHalfCellType)aHalfCellType 
{
    MUHalfCellAlignment alignment = halfCellAlignmentNone;
    if (aHalfCellType == halfCellTypeLeft) 
        alignment = halfCellAlignmentLeft | halfCellAlignmentMiddle;
    else if (aHalfCellType == halfCellTypeRight)
        alignment = halfCellAlignmentRight | halfCellAlignmentTop;
    return alignment;
        
}

//==============================================================================
//==============================================================================
//==============================================================================
@end