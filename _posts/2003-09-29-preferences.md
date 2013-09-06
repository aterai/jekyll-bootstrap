---
layout: post
title: JFrameの位置・サイズを記憶する
category: swing
folder: Preferences
tags: [JFrame, Preferences]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-09-29

## JFrameの位置・サイズを記憶する
`Preferences`(レジストリなど)にフレーム(パネル)の位置・サイズを記憶しておきます。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRGT4S7mI/AAAAAAAAAgo/GDUrxdRJ4x4/s800/Preferences.png)

### サンプルコード
<pre class="prettyprint"><code>public MainPanel(final JFrame frame) {
  super(new BorderLayout());
  this.frame = frame;
  this.prefs = Preferences.userNodeForPackage(getClass());
  frame.addWindowListener(new java.awt.event.WindowAdapter() {
    @Override public void windowClosing(WindowEvent e) {
      saveLocation();
      frame.dispose();
    }
  });
  frame.addComponentListener(new ComponentAdapter() {
    @Override public void componentMoved(ComponentEvent e) {
      if(frame.getExtendedState()==JFrame.NORMAL) {
        Point pt = frame.getLocationOnScreen();
        if(pt.x&lt;0 || pt.y&lt;0) return;
        try{
          pos.setLocation(pt);
        }catch(IllegalComponentStateException icse) {}
      }
    }
    @Override public void componentResized(ComponentEvent e) {
      if(frame.getExtendedState()==JFrame.NORMAL) {
        dim.setSize(getSize());
      }
    }
  });
  exitButton.setAction(new AbstractAction("終了") {
    @Override public void actionPerformed(ActionEvent evt) {
      saveLocation();
      frame.dispose();
    }
  });
  clearButton.setAction(
       new AbstractAction("レジストリなどに保存した値をクリアして終了") {
    @Override public void actionPerformed(ActionEvent evt) {
      try{
        prefs.clear();
        prefs.flush();
      }catch(java.util.prefs.BackingStoreException e) {
        e.printStackTrace();
      }
      frame.dispose();
    }
  });
  int wdim = prefs.getInt(PREFIX+"dimw", dim.width);
  int hdim = prefs.getInt(PREFIX+"dimh", dim.height);
  dim.setSize(wdim, hdim);
  setPreferredSize(dim);

  Rectangle screen = frame.getGraphicsConfiguration().getBounds();
  pos.setLocation(screen.x + screen.width/2  - dim.width/2,
          screen.y + screen.height/2 - dim.height/2);
  int xpos = prefs.getInt(PREFIX+"locx", pos.x);
  int ypos = prefs.getInt(PREFIX+"locy", pos.y);
  pos.setLocation(xpos,ypos);
  frame.setLocation(pos.x, pos.y);
  //......
}
private void saveLocation() {
  prefs.putInt(PREFIX+"locx", pos.x);
  prefs.putInt(PREFIX+"locy", pos.y);
  prefs.putInt(PREFIX+"dimw", dim.width);
  prefs.putInt(PREFIX+"dimh", dim.height);
  try{
    prefs.flush();
  }catch(java.util.prefs.BackingStoreException e) {
    e.printStackTrace();
  }
}
</code></pre>

### 解説
上記のサンプルでは、対象フレームが最大化、最小化された状態で終了した場合、その前の位置サイズを記憶しておくようになっています。

### 参考リンク
- [Preferences API の概要](http://docs.oracle.com/javase/jp/6/technotes/guides/preferences/overview.html)
    - このページの概要にある「`Java` コレクション `API` の設計に関する `FAQ`」は多分、「`Preferences API` の設計に関する `FAQ`」の間違い
- [PersistenceServiceを使ってJFrameの位置・サイズを記憶](http://terai.xrea.jp/Swing/PersistenceService.html)

<!-- dummy comment line for breaking list -->

### コメント
- メモ: [Preferences APIがJava6上では動かない - 日々是開発: SQS Development(2007-02-12)](http://sqs.cmr.sfc.keio.ac.jp/tdiary/20070212.html#p01) -- [aterai](http://terai.xrea.jp/aterai.html) 2007-06-14 (木) 14:42:00
- 最大化した状態で終了すると、`(x,y)`が`(-4,-4)`で記録される。最大化すると、どうやら`JFrame.NORMAL`のまま左端に移動してそれから最大扱いになってるようです。だから`componentMoved`が誤爆してる。 -- [Tomopy](http://terai.xrea.jp/Tomopy.html) 2007-10-26 (金) 12:20:16
    - ご指摘ありがとうございます。位置がマイナスの場合は、保存しないほうがよさそうですね。修正しておきます。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-10-26 (金) 13:37:15

<!-- dummy comment line for breaking list -->

