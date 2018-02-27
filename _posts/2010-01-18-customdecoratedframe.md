---
layout: post
category: swing
folder: CustomDecoratedFrame
title: JFrameのタイトルバーなどの装飾を独自のものにカスタマイズする
tags: [JFrame, MouseListener, MouseMotionListener, JPanel, JLabel, ContentPane, Transparent]
author: aterai
pubdate: 2010-01-18T11:27:29+09:00
description: JFrameのタイトルバーなどを非表示にして独自に描画し、これに移動リサイズなどの機能も追加します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKV1P7mYI/AAAAAAAAAV0/u4qjd-ItBYU/s800/CustomDecoratedFrame.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2010/05/custom-decorated-titlebar-jframe.html
    lang: en
comments: true
---
## 概要
`JFrame`のタイトルバーなどを非表示にして独自に描画し、これに移動リサイズなどの機能も追加します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKV1P7mYI/AAAAAAAAAV0/u4qjd-ItBYU/s800/CustomDecoratedFrame.png %}

## サンプルコード
<pre class="prettyprint"><code>class ResizeWindowListener extends MouseAdapter {
  private Rectangle startSide = null;
  private final JFrame frame;
  public ResizeWindowListener(JFrame frame) {
    this.frame = frame;
  }
  @Override public void mousePressed(MouseEvent e) {
    startSide = frame.getBounds();
  }
  @Override public void mouseDragged(MouseEvent e) {
    if (startSide == null) return;
    Component c = e.getComponent();
    if (c == topleft) {
      startSide.y += e.getY();
      startSide.height -= e.getY();
      startSide.x += e.getX();
      startSide.width -= e.getX();
    } else if (c == top) {
      startSide.y += e.getY();
      startSide.height -= e.getY();
    } else if (c == topright) {
      startSide.y += e.getY();
      startSide.height -= e.getY();
      startSide.width += e.getX();
    } else if (c == left) {
      startSide.x += e.getX();
      startSide.width -= e.getX();
    } else if (c == right) {
      startSide.width += e.getX();
    } else if (c == bottomleft) {
      startSide.height += e.getY();
      startSide.x += e.getX();
      startSide.width -= e.getX();
    } else if (c == bottom) {
      startSide.height += e.getY();
    } else if (c == bottomright) {
      startSide.height += e.getY();
      startSide.width += e.getX();
    }
    frame.setBounds(startSide);
  }
}
</code></pre>

## 解説
上記のサンプルでは`JFrame`の元のタイトルバーを`setUndecorated(true)`で非表示にし、マウスドラッグで移動可能にした`JPanel`を追加してタイトルバーの代わりにしています。

マウスドラッグでのフレームのリサイズは、[Swing - Undecorated and resizable dialog](https://community.oracle.com/thread/1365156)や`BasicInternalFrameUI.java`、`MetalRootPaneUI#MouseInputHandler`などを参考にして、周辺にそれぞれ対応するリサイズカーソルを設定した`JLabel`を配置して実行可能にしています。

- - - -
`JDK 1.7.0`の場合、`JFrame`の背景色を透明(`frame.setBackground(new Color(0x0, true));`)にし、`ContentPane`の左右上の角をクリアして透明にしています。

- - - -
[JRootPaneにリサイズのための装飾を設定する](https://ateraimemo.com/Swing/WindowDecorationStyle.html)のように、`JRootPane#setWindowDecorationStyle(JRootPane.PLAIN_DIALOG);`を使用してリサイズする方法もあります。

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class WindowDecorationStyleTest {
  public JComponent makeTitleBar() {
    JLabel label = new JLabel("Title");
    label.setOpaque(true);
    label.setForeground(Color.WHITE);
    label.setBackground(Color.BLACK);
    DragWindowListener dwl = new DragWindowListener();
    label.addMouseListener(dwl);
    label.addMouseMotionListener(dwl);

    JPanel title = new JPanel(new BorderLayout());
    title.setBorder(BorderFactory.createMatteBorder(0, 4, 4, 4, Color.BLACK));
    title.add(label);
    title.add(new JButton(new AbstractAction("x") {
      @Override public void actionPerformed(ActionEvent e) {
        Window w = SwingUtilities.windowForComponent((Component) e.getSource());
        w.dispatchEvent(new WindowEvent(w, WindowEvent.WINDOW_CLOSING));
      }
    }), BorderLayout.EAST);
    return title;
  }
  public JComponent makeUI() {
    return new JScrollPane(new JTree());
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    JFrame frame = new JFrame();
    frame.setUndecorated(true);

    WindowDecorationStyleTest demo = new WindowDecorationStyleTest();
    JRootPane root = frame.getRootPane();
    root.setWindowDecorationStyle(JRootPane.PLAIN_DIALOG);
    root.setBorder(BorderFactory.createMatteBorder(4, 8, 8, 8, Color.BLACK));
    JLayeredPane layeredPane = root.getLayeredPane();
    Component c = layeredPane.getComponent(1);
    if (c instanceof JComponent) {
      JComponent orgTitlePane = (JComponent) c;
      orgTitlePane.removeAll();
      orgTitlePane.setLayout(new BorderLayout());
      orgTitlePane.add(demo.makeTitleBar());
    }
    frame.setMinimumSize(new Dimension(300, 120));
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.getContentPane().add(demo.makeUI());
    frame.setSize(320, 240);
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
  }
}

class DragWindowListener extends MouseAdapter {
  private final transient Point startPt = new Point();
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
      Point pt = new Point();
      pt = window.getLocation(pt);
      int x = pt.x - startPt.x + me.getX();
      int y = pt.y - startPt.y + me.getY();
      window.setLocation(x, y);
    }
  }
}
</code></pre>

## 参考リンク
- [Swing - Undecorated and resizable dialog](https://community.oracle.com/thread/1365156)
- [JWindowをマウスで移動](https://ateraimemo.com/Swing/DragWindow.html)
- [JInternalFrameをJFrameとして表示する](https://ateraimemo.com/Swing/InternalFrameTitleBar.html)
- [JRootPaneにリサイズのための装飾を設定する](https://ateraimemo.com/Swing/WindowDecorationStyle.html)

<!-- dummy comment line for breaking list -->

## コメント
- `blogger`の方にコメントをもらって、調査、修正中だけど、`dual-monitor`環境が無いのでテストしづらい…。 -- *aterai* 2010-10-06 (水) 13:01:36
- [blogspot](https://java-swing-tips.blogspot.com/2010/05/custom-decorated-titlebar-jframe.html)で指摘されていた件について: このサンプルを`1.6.0_xx`+`WebStart`で実行すると、画面の外にフレームをドラッグすることが出来なかったのですが、`JRE`のバージョンを`1.7.0`にすると、`WebStart`で起動しても画面外に移動可能になっているみたいです。もしかしてデュアルディスプレイでも移動できるようになっているのかも？(未確認...) -- *aterai* 2011-09-06 (火) 21:27:18
- マルチモニター関係のメモ: [Bug ID: 7123767 Wrong tooltip location in Multi-Monitor configurations](https://bugs.openjdk.java.net/browse/JDK-7123767) -- *aterai* 2012-08-14 (火) 13:55:29

<!-- dummy comment line for breaking list -->
