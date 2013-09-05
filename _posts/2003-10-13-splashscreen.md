---
layout: post
title: JWindowを使ったSplash Screenの表示
category: swing
folder: SplashScreen
tags: [JWindow, JLabel]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-10-13

## JWindowを使ったSplash Screenの表示
`JWindow`を使って、`Splash Screen`を表示します。以下のサンプルコードは、`%JAVA_HOME%/demo/jfc/SwingSet2/src/SwingSet2.java`から引用改変したものです。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTTtxuiuuI/AAAAAAAAAk4/JhuyuS80C4M/s800/SplashScreen.png)

### サンプルコード
<pre class="prettyprint"><code>private JWindow splashScreen;
private JLabel  splashLabel;
public MainPanel() {
  super();
  createSplashScreen(SPLASH_PATH);
  EventQueue.invokeLater(new Runnable() {
    @Override public void run() {
      showSplashScreen();
    }
  });
  //長い処理のdummy
  try{
    Thread.sleep(3000);
  }catch(InterruptedException e) {
    System.out.println(e);
  }
  EventQueue.invokeLater(new Runnable() {
    @Override public void run() {
      showPanel();
      hideSplash();
    }
  });
}
public void createSplashScreen(String path) {
  ImageIcon img = new ImageIcon(getClass().getResource(path));
  splashLabel   = new JLabel(img);
  splashScreen  = new JWindow(getFrame());
  splashScreen.getContentPane().add(splashLabel);
  splashScreen.pack();
  splashScreen.setLocationRelativeTo(null);
}
public void showSplashScreen() {
  splashScreen.setVisible(true);
}
public void hideSplash() {
  splashScreen.setVisible(false);
  splashScreen = null;
  splashLabel  = null;
}
public JFrame getFrame() {
  return frame;
}
public void showPanel() {
  this.setPreferredSize(new Dimension(300, 200));
  frame.getContentPane().add(this);
  frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
  frame.pack();
  frame.setLocationRelativeTo(null);
  frame.setVisible(true);
}
</code></pre>

### 解説
上記のサンプルコードでは、クラスパスの通った場所にある`/resources/images/splash.png`を読み込んでスプラッシュ・スクリーン(起動画面)を表示しています。`JWindow`の表示、非表示は、イベントディスパッチスレッド(`EDT`)で行われるように、`EventQueue.invokeLater`の中で実行しています。

- - - -
サンプルの画像は、[n-Gen](http://www.n-generate.com/download.html)を使って生成しています。

- - - -
`Java SE 6`では、起動時にスプラッシュ・スクリーンとして表示する画像をコマンドラインや`manifest.mf`で指定したり、`SplashScreen`オブジェクトを生成して表示することができるようです。

- [SPLASH SCREENS AND JAVA SE 6](http://java.sun.com/developer/JDCTechTips/2005/tt1115.html#1)
- [New Splash-Screen Functionality in Java SE 6](http://java.sun.com/developer/technicalArticles/J2SE/Desktop/javase6/splashscreen/)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JDialogでモーダルなJProgressBar付きSplash Screenを表示する](http://terai.xrea.jp/Swing/ProgressSplashScreen.html)

<!-- dummy comment line for breaking list -->

### コメント
- `Splash Screen`を`Java SE 6`の機能で表示させるために、`splashScreen.setVisible(false)`にしていたテスト版のサンプルが添付されていたのを修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-09-25 (火) 18:56:13

<!-- dummy comment line for breaking list -->
