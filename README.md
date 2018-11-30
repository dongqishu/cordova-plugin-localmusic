# cordova-plugin-localmusic

## 参考
https://github.com/jasminpethani/cordova-plugin-musicplayer

## 作用
扫描本地的音乐文件，有三个方法，分别是：1. 获取所有音乐列表。 2.获取专辑列表。 3.获取歌手列表。

需要与插件cordova-plugin-android-permissions配合使用，原因如下：

Since Android 6.0, the Android permissions checking mechanism has been changed. In the past, the permissions were granted by users when they decide to install the app. Now, the permissions should be granted by a user when he/she is using the app.

For old Android plugins you (developers) are using may not support this new mechanism or already stop updating. So either to find a new plugin to solving this problem, nor trying to add the mechanism in the old plugin. If you don't want to do those, you can try this plugin.

As a convenience we support browser and iOS platforms as well. But this plugin will simple reply that any permission checked of requested was granted.

## 使用示例
<pre>
    <code>
var playList = [];
var that = this;
var permissions = cordova.plugins.permissions;
    //校验app是否有安卓写入权限
    permissions.checkPermission(
      permissions.WRITE_EXTERNAL_STORAGE,
      function(s) {
        //hasPermission 验证是否成功
        if (!s.hasPermission) {
          //没有权限
          //app申请写入权限
          permissions.requestPermission(
            permissions.WRITE_EXTERNAL_STORAGE,
            function(s) {
              if (s.hasPermission) {
                //申请成功
                cordova.plugins.LocalMusic.getMusicList(function(msg) {
                  console.log(msg);
                  if (msg && msg.length > 51) {
                    that.playList = msg;
                  }
                });
                // cordova.plugins.LocalMusic.getAlbums(function(msg) {
                //   console.log(msg);
                // });
                // cordova.plugins.LocalMusic.getArtists(function(msg) {
                //   console.log(msg);
                // });
              } else {
                //申请失败
              }
            },
            function(error) {}
          );
        } else {
          //拥有权限
          cordova.plugins.LocalMusic.getMusicList(function(msg) {
            console.log(msg);
            if (msg && msg.length > 51) {
              that.playList = msg;
            }
          });
          // cordova.plugins.LocalMusic.getAlbums(function(msg) {
          //   console.log(msg);
          // });
          // cordova.plugins.LocalMusic.getArtists(function(msg) {
          //   console.log(msg);
          // });
        }
      },
      function(error) {}
    );
    </code>
</pre>



cordova plugin retrieve local music
