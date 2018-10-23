---
layout: post
category: swing
folder: SplashScreen
title: JWindowを使ったSplash Screenの表示
tags: [JWindow, JLabel]
author: aterai
pubdate: 2003-10-13T06:25:21+09:00
description: JWindowを使って、Splash Screenを表示します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTtxuiuuI/AAAAAAAAAk4/JhuyuS80C4M/s800/SplashScreen.png
comments: true
---
## 概要
`JWindow`を使って、`Splash Screen`を表示します。以下のサンプルコードは、`%JAVA_HOME%/demo/jfc/SwingSet2/src/SwingSet2.java`から引用改変したものです。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTtxuiuuI/AAAAAAAAAk4/JhuyuS80C4M/s800/SplashScreen.png %}

## サンプルコード
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
  try {
    Thread.sleep(3000);
  } catch (InterruptedException e) {
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

## 解説
上記のサンプルコードでは、クラスパスの通った場所にある`/resources/images/splash.png`を読み込んでスプラッシュ・スクリーン(起動画面)を表示しています。`JWindow`の表示、非表示は、イベントディスパッチスレッド(`EDT`)で行われるように、`Runnable`を作成し`EventQueue.invokeLater()`メソッドで実行しています。

- - - -
- `Java SE 6`では、[SplashScreen](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/SplashScreen.html)クラスが追加され、起動時にスプラッシュ・スクリーンとして表示する画像をコマンドラインや`manifest.mf`で指定するなどの方法で使用可能になった
    - [SPLASH SCREENS AND JAVA SE 6](http://web.archive.org/web/20090419180550/http://java.sun.com/developer/JDCTechTips/2005/tt1115.html#1)
    - [New Splash-Screen Functionality in Java SE 6](http://www.oracle.com/technetwork/articles/javase/splashscreen-135938.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JDialogでモーダルなJProgressBar付きSplash Screenを表示する](https://ateraimemo.com/Swing/ProgressSplashScreen.html)
- ~~[n-Gen](http://www.n-generate.com/download.html)~~
    - サンプルの画像の生成に利用

<!-- dummy comment line for breaking list -->

## コメント
- `Splash Screen`を`Java SE 6`の機能で表示させるために、`splashScreen.setVisible(false)`にしていたテスト版のサンプルが添付されていたのを修正しました。 -- *aterai* 2007-09-25 (火) 18:56:13

<!-- dummy comment line for breaking list -->
