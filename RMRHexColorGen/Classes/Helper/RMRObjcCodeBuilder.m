//
//  RMRColorCategoryBuilder.m
//  RMRHexColorGen
//
//  Created by Roman Churkin on 19/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

#import "RMRObjcCodeBuilder.h"

#import "RXCollection.h"

// Helper
#import "NSString+RMRHelpers.h"
#import "NSColor+Hexadecimal.h"

// Model
#import "RMRHexColor.h"

#pragma mark — Constants

static NSString * const kTemplateKeyInputFileName = @"<*input_file_name*>";
static NSString * const kTemplateKeyClassName     = @"<*class_name*>";
static NSString * const kTemplateKeyPathClassName = @"<*path_class_name*>";
static NSString * const kTemplateKeyMethods       = @"<*methods*>";
static NSString * const kTemplateKeyFrameworkName = @"<*import_framework_name*>";

static NSString * const kColorCategoryHeaderTemplate =
@"//\n//  <*path_class_name*>.h\n//  (This file was autogenerated by RMRHexColorGen, which parsed an input file of: <*input_file_name*>.\n"
@"//  Do not modify as it can easily be overwritten.)\n"
@"//\n"
@"\n@import <*import_framework_name*>;\n\n"
@"\n@interface <*class_name*>\n"
@"\n<*methods*>"
@"@end\n";

static NSString * const kColorCategorySourceTemplate =
@"//\n//  <*path_class_name*>.m\n//  (This file was autogenerated by RMRHexColorGen, which parsed an input file of: <*input_file_name*>.\n"
@"//  Do not modify as it can easily be overwritten.)\n"
@"//\n"
@"\n#import \"<*path_class_name*>.h\"\n\n"
@"\n@implementation <*class_name*>\n"
@"\n<*methods*>"
@"@end\n";


@interface RMRObjcCodeBuilder ()

#pragma mark — Properties
@property (nonatomic, copy) RMRHexColorGenParameters *parameters;

@property (nonatomic, copy) NSString *colorClassName;
@property (nonatomic, copy) NSString *appFrameworkName;
@property (nonatomic, copy) NSDate   *initializationDate;

@end


@implementation RMRObjcCodeBuilder

- (instancetype)initWithParameters:(RMRHexColorGenParameters *)parameters {
    self = [super init];
    if (self) {
        _parameters = parameters;
        _initializationDate = [NSDate date];
        _colorClassName = parameters.isForOSX ? @"NSColor" : @"UIColor";
        _appFrameworkName = parameters.isForOSX ? @"AppKit" : @"UIKit";
        
    }
    return self;
}
    
- (NSError *)generateColorCategoryForColors:(NSArray *)colorList
{
    NSError *error = nil;
    
    NSString *outputFolder = self.parameters.outputPath;
    
    error = [self buildHeaderFileForColors:colorList outputPath:outputFolder];
    if (error) return error;
    
    error = [self buildSourceFileForColors:colorList outputPath:outputFolder];
    if (error) return error;
    
    return error;
}

- (NSError *)buildHeaderFileForColors:(NSArray *)colorList outputPath:(NSString *)outputPath
{
    NSString *inputFilename = self.parameters.inputPath.lastPathComponent;
    NSString *className     = [self buildClassName];
    NSString *pathClassName = [self buildPathClassName];
    NSString *methods       = [self buildMethodGroupForHeaderFileWithColorList:colorList];
 
    
    
    NSString *headerFile =
    [[[[[kColorCategoryHeaderTemplate
         stringByReplacingOccurrencesOfString:kTemplateKeyFrameworkName withString:_appFrameworkName]
        stringByReplacingOccurrencesOfString:kTemplateKeyInputFileName withString:inputFilename]
       stringByReplacingOccurrencesOfString:kTemplateKeyClassName     withString:className]
      stringByReplacingOccurrencesOfString:kTemplateKeyPathClassName withString:pathClassName]
     stringByReplacingOccurrencesOfString:kTemplateKeyMethods       withString:methods];
    
    NSString *outputFilePath =
    [[outputPath stringByAppendingPathComponent:pathClassName] stringByAppendingString:@".h"];
    
    NSError *error = nil;
    [headerFile writeToFile:outputFilePath
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:&error];
    
    return error;
}

- (NSError *)buildSourceFileForColors:(NSArray *)colorList outputPath:(NSString *)outputPath
{
    NSString *inputFilename = self.parameters.inputPath.lastPathComponent;
    NSString *className     = [self buildClassName];
    NSString *pathClassName = [self buildPathClassName];
    
    NSString *methods;
    if(self.parameters.useValuesNotNames) {
        methods = [self buildValueBasedColorListForSourceFileWithColorList:colorList];
    } else {
        methods = [self buildNamedColorListForSourceFileWithColorList:colorList];
    }
    
    
    NSString *headerFile =
    [[[[kColorCategorySourceTemplate
        stringByReplacingOccurrencesOfString:kTemplateKeyInputFileName withString:inputFilename]
       stringByReplacingOccurrencesOfString:kTemplateKeyClassName     withString:className]
      stringByReplacingOccurrencesOfString:kTemplateKeyPathClassName withString:pathClassName]
     stringByReplacingOccurrencesOfString:kTemplateKeyMethods       withString:methods];
    
    NSString *outputFilePath =
    [[outputPath stringByAppendingPathComponent:pathClassName] stringByAppendingString:@".m"];
    
    NSError *error = nil;
    [headerFile writeToFile:outputFilePath
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:&error];
    
    return error;
}




#pragma mark — Private helper

- (NSString *)buildClassName
{
    return [NSString stringWithFormat:@"%@ (%@)", self.colorClassName, self.parameters.name];
}

- (NSString *)buildPathClassName
{
    return [NSString stringWithFormat:@"%@+%@", self.colorClassName, self.parameters.name];
}

- (NSString *)buildCreateDate
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    
    return [dateFormatter stringFromDate:self.initializationDate];
}

- (NSString *)buildMethodSignatureForColor:(RMRHexColor *)hexColor
{
    static NSString * colorClassKey = @"<*color_class*>";
    static NSString * prefixKey    = @"<*prefix*>";
    static NSString * colorNameKey = @"<*color_name*>";
    static NSString * commentsKey = @"<*color_comments*>";
    
    static NSString *colorMethodSignatureTemplate =
    @"<*color_comments*>\n"
    @"+ (<*color_class*> *)<*prefix*><*color_name*>Color";
    
    NSString *prefix = [self.parameters.prefix lowercaseString];
    prefix = prefix? [prefix stringByAppendingString:@"_"] : @"";
    
    NSString *colorName = [hexColor.colorTitle RMR_lowercaseFirstSymbol];
    
    NSString *commentsValue;
    if(hexColor.comments.length > 0) {
        commentsValue = [NSString stringWithFormat: @"// #%@ - %@", hexColor.colorValue, hexColor.comments];
    } else {
        commentsValue = [NSString stringWithFormat: @"// #%@", hexColor.colorValue];
    }
    
    return
    [[[[colorMethodSignatureTemplate
        stringByReplacingOccurrencesOfString:colorClassKey withString:self.colorClassName]
       stringByReplacingOccurrencesOfString:prefixKey withString:prefix]
      stringByReplacingOccurrencesOfString:colorNameKey withString:colorName]
     stringByReplacingOccurrencesOfString:commentsKey withString:commentsValue];
}

- (NSString *)buildMethodGroupForHeaderFileWithColorList:(NSArray *)colorList
{
    // the colorList will be sorted first with defined colors, then aliases.
    // so the first alias we encounter, we should generate some more text
    __block BOOL firstColor = YES;
    __block BOOL definedColorsFinished = NO;
    __block BOOL firstReference = NO;
    
    return
    [[colorList rx_mapWithBlock:^id(RMRHexColor *hexColor) {
        
        NSString *sectionComments = nil;
        
        if(firstColor) {
            sectionComments = @"//-------- Defined Colors with Provided Hex Values\n\n";
            firstColor = NO;
        }
        
        // this works because the assumption is that colorList has been sorted first by non-aliases then aliases.
        if(hexColor.isAlias && !definedColorsFinished) {
            definedColorsFinished = YES;
            firstReference = YES;
        }
        
        if (firstReference) {
            sectionComments = @"\n\n//-------- Color Aliases who are references to defined colors above:\n\n";
            firstReference = NO;
        }
        
        NSString *outputLine = [[self buildMethodSignatureForColor:hexColor] stringByAppendingString:@";\n"];
        
        if (sectionComments) {
            return [sectionComments stringByAppendingString:outputLine];
        } else {
            return outputLine;
        }
        
    }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
        return [[memo stringByAppendingString:each] stringByAppendingString:@"\n"];
    }];
}
    
- (NSString *)buildNamedColorListForSourceFileWithColorList:(NSArray *)colorList {
    
    static NSString * signatureKey = @"<*method_signature*>";
    static NSString * colorNameKey = @"<*color_name*>";
    NSString *methodTemplate;
    
    if(self.parameters.isForOSX)
    {
        methodTemplate =
        @"<*method_signature*>\n{\n"
        @"    return [NSColor colorNamed:<*color_name*>];\n"
        @"}\n";
    }
    else
    {
        methodTemplate =
        @"<*method_signature*>\n{\n"
        @"    return [UIColor colorNamed:<*color_name*>];\n"
        @"}\n";
    }
    
    return
    [[colorList rx_mapWithBlock:^id(RMRHexColor *hexColor) {
        NSString *methodSignature = [self buildMethodSignatureForColor:hexColor];
        
        return
        [[methodTemplate
             stringByReplacingOccurrencesOfString:signatureKey withString:methodSignature]
            stringByReplacingOccurrencesOfString:colorNameKey withString:hexColor.colorTitle];
        
    }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
        return [[memo stringByAppendingString:each] stringByAppendingString:@"\n"];
    }];
}

- (NSString *)buildValueBasedColorListForSourceFileWithColorList:(NSArray *)colorList
{
    static NSString * signatureKey = @"<*method_signature*>";
    static NSString * redKey       = @"<*red*>";
    static NSString * greenKey     = @"<*green*>";
    static NSString * blueKey      = @"<*blue*>";
    static NSString * alphaKey     = @"<*alpha*>";
    
    NSString *methodTemplate;
    
    if(self.parameters.isForOSX)
    {
        methodTemplate =
        @"<*method_signature*>\n{\n"
        @"    return [NSColor colorWithSRGBRed:<*red*>\n"
        @"                               green:<*green*>\n"
        @"                                blue:<*blue*>\n"
        @"                               alpha:<*alpha*>];\n"
        @"}\n";
    }
    else
    {
        methodTemplate =
        @"<*method_signature*>\n{\n"
        @"    return [UIColor colorWithRed:<*red*>\n"
        @"                           green:<*green*>\n"
        @"                            blue:<*blue*>\n"
        @"                           alpha:<*alpha*>];\n"
        @"}\n";
    }
    
    
    
    return
    [[colorList rx_mapWithBlock:^id(RMRHexColor *hexColor) {
        NSString *methodSignature = [self buildMethodSignatureForColor:hexColor];
        
        NSColor *rgbColor = [NSColor colorWithHexString:hexColor.colorValue];
        
        NSString *redComponent   = [@(rgbColor.redComponent) stringValue];
        NSString *greenComponent = [@(rgbColor.greenComponent) stringValue];
        NSString *blueComponent  = [@(rgbColor.blueComponent) stringValue];
        NSString *alphaComponent = [@(rgbColor.alphaComponent) stringValue];
        
        return
        [[[[[methodTemplate
             stringByReplacingOccurrencesOfString:signatureKey withString:methodSignature]
            stringByReplacingOccurrencesOfString:redKey       withString:redComponent]
           stringByReplacingOccurrencesOfString:greenKey     withString:greenComponent]
          stringByReplacingOccurrencesOfString:blueKey      withString:blueComponent]
         stringByReplacingOccurrencesOfString:alphaKey     withString:alphaComponent];
        
    }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
        return [[memo stringByAppendingString:each] stringByAppendingString:@"\n"];
    }];
}

@end
