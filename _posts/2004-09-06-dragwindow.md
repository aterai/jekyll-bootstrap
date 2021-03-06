---
layout: post
category: swing
folder: DragWindow
title: JWindowをマウスで移動
tags: [JWindow, JFrame, MouseListener, MouseMotionListener]
author: aterai
pubdate: 2004-09-06T00:58:19+09:00
description: JWindowなどのタイトルバーのないフレームをマウスで移動します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTL8cG8F0I/AAAAAAAAAYY/vZfyqnyr6-I/s800/DragWindow.png
comments: true
---
## 概要
`JWindow`などのタイトルバーのないフレームをマウスで移動します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTL8cG8F0I/AAAAAAAAAYY/vZfyqnyr6-I/s800/DragWindow.png %}

## サンプルコード
<pre class="prettyprint"><code>public void createSplashScreen(String path) {
  ImageIcon img = new ImageIcon(getClass().getResource(path));
  DragWindowListener dwl = new DragWindowListener();
  splashLabel = new JLabel(img);
  splashLabel.addMouseListener(dwl);
  splashLabel.addMouseMotionListener(dwl);
  splashScreen = new JWindow(getFrame());
  splashScreen.getContentPane().add(splashLabel);
  splashScreen.pack();
  splashScreen.setLocationRelativeTo(null);
}
class DragWindowListener extends MouseAdapter {
  private final Point startPt = new Point();
  //private Point  loc;
  private Window window;
  @Override public void mousePressed(MouseEvent me) {
    startPt.setLocation(me.getPoint());
  }
  @Override public void mouseDragged(MouseEvent me) {
    if (window == null) {
      window = SwingUtilities.windowForComponent(me.getComponent());
    }
    Point eventLocationOnScreen = me.getLocationOnScreen();
    window.setLocation(eventLocationOnScreen.x - startPt.x,
                       eventLocationOnScreen.y - startPt.y);
    //loc = window.getLocation(loc);
    //int x = loc.x - start.getX() + me.getX();
    //int y = loc.y - start.getY() + me.getY();
    //window.setLocation(x, y);
  }
}
</code></pre>

## 解説
`JWindow`や、`setUndecorated(true)`した`JFrame`のようにタイトルバーのないフレームをマウスのドラッグで移動します。実際は`JWindow`自体にリスナーを設定するのではなく、子コンポーネントに`MouseMotionListener`などを追加しています。

上記のサンプルでは`JLabel`にリスナーを追加し、これを`JWindow`に配置してドラッグ可能にしています。

スプラッシュスクリーンの次に開く`JFrame`は、`JFrame#setUndecorated(true)`を設定してタイトルバーなどは非表示になっていますが、代わりに青いラベル部分がドラッグ可能です。

- - - -
- マルチディスプレイなどで、別画面に移動できないバグ？を修正
    - ただし、`Web Start`の`SandBox`内では、以前と同じく画面の外までは移動不可？
        - `JNLP`のセキュリティに`all-permissions`を設定する必要がある
- `Swing Tutorial`の [FrameDemo2](https://docs.oracle.com/javase/tutorial/uiswing/examples/components/index.html#FrameDemo2)で試しても、同様？
    - `Look and feel decorated`: 画面外に移動不可
    - `Window system decorated`: 画面外に移動可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JInternalFrameをJFrameとして表示する](https://ateraimemo.com/Swing/InternalFrameTitleBar.html)
- [JFrameのタイトルバーなどの装飾を独自のものにカスタマイズする](https://ateraimemo.com/Swing/CustomDecoratedFrame.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JLabel`無しで`JFrame`を直接つかんで移動させようと，ソース中の`DragWindowListener`を`Frame`の引数に指定して`addMouseListener()`，`addMouseMotionListener()`に追加してみたのですが，うまく動きませんでした。ラベルではなくフレームを直接つかんで移動させるにはどうすればよいのでしょうか？ -- *hshs* 2013-03-14 (木) 08:00:42
    - `frame.getContentPane().addMouseListener(dwl);...`と、`ContentPane`か`RootPane`に`DragWindowListener`を追加するか、以下のように`DragWindowListener`を変更するのはどうでしょうか？ -- *aterai* 2013-03-14 (木) 13:53:25

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
public class MainPanel {
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    DragWindowListener dwl = new DragWindowListener();
    JFrame frame = new JFrame();
    frame.setUndecorated(true);
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.addMouseListener(dwl);
    frame.addMouseMotionListener(dwl);
    frame.setSize(320, 240);
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
  }
}
class DragWindowListener extends MouseAdapter {
  private final Point startPt = new Point();
  private Window window;
  @Override public void mousePressed(MouseEvent me) {
    if (window == null) {
      Object o = me.getSource();
      if (o instanceof Window) {
        window = (Window) o;
      } else if (o instanceof JComponent) {
        window = SwingUtilities.windowForComponent(me.getComponent());
      }
    }
    startPt.setLocation(me.getPoint());
  }
  @Override public void mouseDragged(MouseEvent me) {
    if (window != null) {
      Point eventLocationOnScreen = me.getLocationOnScreen();
      window.setLocation(eventLocationOnScreen.x - startPt.x,
                         eventLocationOnScreen.y - startPt.y);
    }
  }
}
</code></pre>
- えーと、このソースは新たに`JPanel`を継承してるんですね、という事は結局、`JFrame`自体をマウスドラッグでつかむことが出来ないということなんでしょうか？ -- *hshs* 2013-03-15 (金) 11:08:52
    - `JFrame`の`ContentPane`に`JPanel`を継承したダミーコンポーネントをサンプルとして追加してるだけです。必要ないなら上記のように削除して(どこを削除したかはこのページ上にある「編集された箇所をみる」などで調べてください)調査してみるのがお手軽なのでオススメです。`JFrame`に追加したリスナーで`JFrame`の移動を行うことは可能ですが、本当に「`JFrame`自体をマウスドラッグでつかむことが出来ない」かどうかについては、内部での処理を追っていないのでよく分かりません。 -- *aterai* 2013-03-15 (金) 13:56:42
- 返信ありがとうございます，最初のサンプル中の`createAndShowGUI()`内や，`showFrame()`や，`start(JFrame frame)`内などに，`DragWindowListener dwl = new DragWindowListener();`と`frame.addMouseListener(dwl);`と`frame.addMouseMotionListener(dwl);`を入れて見たりしたのですが動作しないのですが，これは何故なんでしょうか？、何か必要な命令が足りないのでしょうか。 -- *hshs* 2013-03-15 (金) 22:34:12
    - 失礼、見落としてました。自分の環境(`JDK 1.7.0_17`, `Windows 7`)では、特に問題なく動作(`Exception`なども出ていない)しています。環境と変更したソース自体をどこか(例えば https://gist.github.com/ とか)に投稿できますか？ -- *aterai* 2013-03-18 (月) 15:34:53
- あっ、動作しないというのは「`JFrame`自体をマウスドラッグでつかむことが出来ない」という意味で，通常の動作は問題ないです，上記のように追加変更して見たら，ラベルの部分だけでなく真ん中のフレーム部分を，マウスでドラッグしてつかんで移動させられるのかなと思ったのですが，実際つかんで移動させようとすると，`Exception in thread "AWT-EventQueue-0" java.lang.NullPointerException`が出てきてつかめなかったので....。GitHubのアカウントは持ってないですｗ，環境は`JDK1.7.0_15`,`win7`,`64bit`,ソースは上の三行を追加してみただけです。 --  2013-03-19 (火) 04:21:51
    - 「上の三行を追加してみただけ」だと`DragWindowListener`が新しくなっていない(コメントの`DragWindowListener`になっていない)ので、`NullPointerException`が発生していると考えて良さそうです(ソースコードの行とかが分からないので推測ですが)。`src.zip`やリポジトリの`DragWindowListener`も更新した(ついでに上記のコメントの`DragWindowListener`もアップデート)ので、最新版で試してみてください。 -- *aterai* 2013-03-19 (火) 16:03:51
    - 余談: gistってアカウント必要でしたっけ？ -- *aterai* 2013-03-19 (火) 16:05:24
- gistってアカウント無しで投稿出来るんですね，知りませんでしたm(__)m，再UPしていただいた`src.zip`で上記の動作を確認できました。ありがとうございます。`DragWindowListener`内部の追加されていたコードの意味が自分にはまだ理解できませんが，もっと勉強したいと思います。 -- *hshs* 2013-03-20 (水) 06:49:58

<!-- dummy comment line for breaking list -->
