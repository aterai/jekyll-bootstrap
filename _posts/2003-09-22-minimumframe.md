---
layout: post
title: JFrameの最小サイズ
category: swing
folder: MinimumFrame
tags: [JFrame, JDialog]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-09-22

## JFrameの最小サイズ
`JFrame`や`JDialog`の最小サイズを指定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTP41PdCsI/AAAAAAAAAes/cxniHSm55rQ/s800/MinimumFrame.png)

### サンプルコード
<pre class="prettyprint"><code>//1.6以上で有効
frame.setMinimumSize(new Dimension(320, 150));
</code></pre>

### 解説
上記のサンプルでは、`JFrame`などを縮小する際の最小サイズを設定しています。

`JDK 1.6`以上の場合、`JFrame#setMinimumSize`メソッドを使用することで、最小サイズを指定することができます。

`JDK 1.5`で、`JFrame#setMinimumSize`メソッドを使う場合は、`JFrame.setDefaultLookAndFeelDecorated(true)`、かつウインドウのリサイズに応じてレイアウトを再評価するようにしておく必要があるようです。

<pre class="prettyprint"><code>JFrame.setDefaultLookAndFeelDecorated(true);
Toolkit.getDefaultToolkit().setDynamicLayout(true);
</code></pre>

- - - -
`JFrame#setMinimumSize`メソッドを使わず、`ComponentListener`でサイズを制限する場合は、この制限を超えて縮小しようとしても、マウスを放した時点で設定した最小サイズまでフレームの大きさは戻されます。

<pre class="prettyprint"><code>//ComponentListenerを使用
final int mw = 320;
final int mh = 100;
final JFrame frame = new JFrame();
frame.addComponentListener(new ComponentAdapter() {
  public void componentResized(ComponentEvent e) {
    int fw = frame.getSize().width;
    int fh = frame.getSize().height;
    frame.setSize((mw&gt;fw)?mw:fw, (mh&gt;fh)?mh:fh);
  }
});

//JFrame#validateをオーバーライド
//final Dimension minDim = new Dimension(320, 100);
//JFrame frame = new JFrame() {
//  public void validate() {
//    Rectangle rect = getBounds();
//    if(minDim.width&gt;rect.width || minDim.height&gt;rect.height) {
//      int mw = ((minDim.width&gt;rect.width)?minDim.width:rect.width);
//      int mh = ((minDim.height&gt;rect.height)?minDim.height:rect.height);
//      setBounds(rect.x, rect.y, mw, mh);
//    }
//    super.validate();
//  }
//};
</code></pre>

`JFrame#setMaximumSize`が無効な環境でも、上記のように`ComponentListener`を使えば最大サイズを制限する(リサイズした後で最大サイズに戻しているだけ)ことができます。

- - - -
`Robot`を使う方法もあるようです。

- [Bug ID: 6464548 Reopen 6383434: Frame.setMaximumSize() doesn't work](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6464548)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
public class MaximumSizeTest{
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      public void run() { createAndShowGUI(); }
    });
  }
  private static final int MAX = 500;
  public static void createAndShowGUI() {
    final JFrame frame = new JFrame();
    frame.setMinimumSize(new Dimension(240,120));
    //frame.setMaximumSize(new Dimension(400,400));
    Robot r;
    final Robot r2;
    try{
      r = new Robot();
    }catch (AWTException ex) {
      r = null;
    }
    r2 = r;
    frame.getRootPane().addComponentListener(new ComponentAdapter() {
      public void componentResized(ComponentEvent e) {
        Point loc   = frame.getLocationOnScreen();
        Point mouse = MouseInfo.getPointerInfo().getLocation();
        if(r2!=null &amp;&amp; (mouse.getX()&gt;loc.getX()+MAX ||
                        mouse.getY()&gt;loc.getY()+MAX)) {
          r2.mouseRelease(InputEvent.BUTTON1_MASK);
          frame.setSize(Math.min(MAX, frame.getWidth()),
                        Math.min(MAX, frame.getHeight()));
        }
      }
    });
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.setSize(320, 240);
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
  }
}
</code></pre>

### 参考リンク
- [Swing - Have JFrame respect the minimum size (stop resizing) - Partial solution](https://forums.oracle.com/thread/1377749)
- [DynamicLayoutでレイアウトの動的評価](http://terai.xrea.jp/Swing/DynamicLayout.html)

<!-- dummy comment line for breaking list -->

### コメント
- 最大サイズも同じ要領で・・・とありますが`JFrame#setMaximumSize`はうまくいかないですね（`JDK1.6.0_u1`）色々調べているのですが、いい方法あるんでしょうか？ -- [sawshun](http://terai.xrea.jp/sawshun.html) 2009-07-27 (月) 11:51:11
    - 同じ要領なのは、`ComponentListener`を使う場合…のつもりです。~~わかりづらいのであとで修正しますm(_ _)m。~~ すこし修正しました。`setMaximumSize`は、ちょっと難しいのかも([Bug ID: 6200438 Frame's size must be validated against maximized bounds when resizing, win32](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6200438))。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-07-27 (月) 12:05:33

<!-- dummy comment line for breaking list -->
