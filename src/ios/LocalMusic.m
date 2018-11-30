#import <Cordova/CDV.h>
#import "LocalMusic.h"

-(void)getMusicList:(CDVInvokedUrlCommand *)command{
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSArray *itemsFromGenericQuery = [everything items];
    NSMutableArray *allSongs = [[NSMutableArray alloc] init];
    for (MPMediaItem *song in itemsFromGenericQuery) {
        NSMutableDictionary *songDictionary = [[NSMutableDictionary alloc] init];
        NSString *songId = [NSString stringWithFormat:@"%@",[song valueForProperty:MPMediaEntityPropertyPersistentID]];
        NSString *albumId = [NSString stringWithFormat:@"%@",[song valueForProperty:MPMediaItemPropertyAlbumPersistentID]];
        NSString *artistId = [NSString stringWithFormat:@"%@",[song valueForProperty:MPMediaItemPropertyArtistPersistentID]];
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSString *albumTitle = [NSString stringWithFormat:@"%@ ",[song valueForProperty: MPMediaItemPropertyAlbumTitle]];
        NSString *artistTitle = [NSString stringWithFormat:@"%@ ",[song valueForProperty: MPMediaItemPropertyArtist]];
        NSNumber *duration = [NSNumber numberWithLong:[[song valueForKey:MPMediaItemPropertyPlaybackDuration] longValue] * 1000];
        [songDictionary setObject:songId forKey:@"id"];
        [songDictionary setObject:albumId forKey:@"album_id"];
        [songDictionary setObject:artistId forKey:@"artist_id"];
        [songDictionary setObject:songTitle forKey:@"displayName"];
        [songDictionary setObject:albumTitle forKey:@"albumName"];
        [songDictionary setObject:artistTitle forKey:@"artistName"];
        [songDictionary setObject:duration forKey:@"duration"];
        [allSongs addObject:songDictionary];
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[allSongs copy]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)getAlbums:(CDVInvokedUrlCommand *)command{
    NSMutableArray *allAlbums = [[NSMutableArray alloc] init];
    for (MPMediaItemCollection *collection in [[MPMediaQuery albumsQuery] collections]) {

        NSMutableDictionary *albumDictionary = [[NSMutableDictionary alloc] init];
        MPMediaItem *album = [collection representativeItem];
        UIImage *image = [[album valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(100, 100)];
        NSData *data = UIImagePNGRepresentation(image);
        NSString *encodedString = [NSString stringWithFormat:@"data:image/png;base64,%@",[data base64Encoding]];
        NSString *albumId = [NSString stringWithFormat:@"%@",[album valueForProperty:MPMediaItemPropertyAlbumPersistentID]];
        NSString *albumTitle = [album valueForKey:MPMediaItemPropertyAlbumTitle];
        NSString *artistTitle = [NSString stringWithFormat:@"%@ ",[album valueForProperty: MPMediaItemPropertyArtist]];
        NSNumber *noOfSongs = [album valueForKey:MPMediaItemPropertyAlbumTrackCount];
        
        [albumDictionary setObject:albumId forKey:@"id"];
        [albumDictionary setObject:albumTitle forKey:@"displayName"];
        [albumDictionary setObject:encodedString forKey:@"image"];
        [albumDictionary setObject:artistTitle forKey:@"artist"];
        [albumDictionary setObject:noOfSongs forKey:@"noOfSongs"];
        [allAlbums addObject:albumDictionary];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[allAlbums copy]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)getArtists:(CDVInvokedUrlCommand *)command{
    NSMutableArray *allArtists = [[NSMutableArray alloc] init];
    for (MPMediaItemCollection *collection in [[MPMediaQuery artistsQuery] collections]) {
        NSMutableDictionary *artistDictionary = [[NSMutableDictionary alloc] init];
        MPMediaItem *artist = [collection representativeItem];
        NSString *artistId = [NSString stringWithFormat:@"%@",[artist valueForProperty:MPMediaItemPropertyArtistPersistentID]];
        NSString *artistTitle = [NSString stringWithFormat:@"%@ ",[artist valueForProperty: MPMediaItemPropertyArtist]];
        
        [artistDictionary setObject:artistId forKey:@"id"];
        [artistDictionary setObject:artistTitle forKey:@"artistName"];
        [allArtists addObject:artistDictionary];
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[allArtists copy]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
