---
layout: post
category: swing
folder: MenuBarBackground
title: JMenuBarの背景に画像を表示する
tags: [JMenuBar, JMenu, JMenuItem, TexturePaint]
author: aterai
pubdate: 2009-08-10T15:27:32+09:00
description: JMenuBarの背景に画像を表示します。
comments: true
---
## 概要
`JMenuBar`の背景に画像を表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTPxQA13fI/AAAAAAAAAeg/SAN79wHPkQc/s800/MenuBarBackground.png %}

## サンプルコード
<pre class="prettyprint"><code>public JMenuBar createMenubar() {
  final TexturePaint texture = makeTexturePaint();
  JMenuBar mb = new JMenuBar() {
    @Override protected void paintComponent(Graphics g) {
      super.paintComponent(g);
      Graphics2D g2 = (Graphics2D)g;
      g2.setPaint(texture);
      g2.fillRect(0, 0, getWidth(), getHeight());
    }
  };
  mb.setOpaque(false);
  String[] menuKeys = {"File", "Edit", "Help"};
  for(String key: menuKeys) {
    JMenu m = createMenu(key);
    if(m != null) mb.add(m);
  }
  return mb;
}
private JMenu createMenu(String key) {
  JMenu menu = new JMenu(key) {
    @Override protected void fireStateChanged() {
      ButtonModel m = getModel();
      if(m.isPressed() &amp;&amp; m.isArmed()) {
        setOpaque(true);
      }else if(m.isSelected()) {
        setOpaque(true);
      }else if(isRolloverEnabled() &amp;&amp; m.isRollover()) {
        setOpaque(true);
      }else{
        setOpaque(false);
      }
      super.fireStateChanged();
    };
  };
  if("Windows XP".equals(System.getProperty("os.name"))) {
    menu.setBackground(new Color(0,0,0,0)); //XXX Windows XP lnf?
  }
  menu.add("dummy1"); menu.add("dummy2"); menu.add("dummy3");
  return menu;
}
</code></pre>

## 解説
上記のサンプルでは、`JMenuBar`に画像を描画し、これに追加する`JMenu`を通常は透明、選択されたときなどは不透明となるように`setOpaque`メソッドで切り替えています。

- 注意点
    - `WindowsLookAndFeel`の場合、`JMenu#setBackground(new Color(0,0,0,0));`とする必要がある？
    - ~~`NimbusLookAndFeel`には対応していない~~
    - `WindowsLookAndFeel`に切り替えた直後、メニューの文字色などがおかしい？

<!-- dummy comment line for breaking list -->

- - - -
`JFrame#setJMenuBar()`で追加した`JMenuBar`を透明にする場合のテスト

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.image.*;
import javax.swing.*;
public class MenuBarRootPaneTest {
  private static JMenuBar createMenubar() {
    JMenuBar mb = new JMenuBar();
    mb.setOpaque(false);
    mb.setBackground(new Color(0,0,0,0));
    String[] menuKeys = {"File", "Edit", "Help"};
    for(String key: menuKeys) {
      JMenu m = createMenu(key);
      if(m != null) mb.add(m);
    }
    return mb;
  }
  private static JMenu createMenu(String key) {
    JMenu menu = new JMenu(key);
    menu.setForeground(Color.WHITE);
    menu.add("dummy1");
    menu.add("dummy2");
    menu.add("dummy3");
    return menu;
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  private static TexturePaint makeTexturePaint() {
    int cs = 6, sz = cs*cs;
    BufferedImage img = new BufferedImage(sz,sz,BufferedImage.TYPE_INT_ARGB);
    Graphics2D g2 = img.createGraphics();
    g2.setPaint(new Color(222,222,222,50));
    g2.fillRect(0,0,sz,sz);
    for(int i=0; i*cs&lt;sz; i++) {
      for(int j=0; j*cs&lt;sz; j++) {
        if((i+j)%2==0) g2.fillRect(i*cs, j*cs, cs, cs);
      }
    }
    g2.dispose();
    return new TexturePaint(img, new Rectangle(0,0,sz,sz));
  }
  public static void createAndShowGUI() {
    JFrame frame = new JFrame() {
      @Override protected JRootPane createRootPane() {
        JRootPane rp = new JRootPane() {
          private final TexturePaint texture = makeTexturePaint();
          @Override protected void paintComponent(Graphics g) {
            super.paintComponent(g);
            Graphics2D g2 = (Graphics2D)g.create();
            g2.setPaint(texture);
            g2.fillRect(0, 0, getWidth(), getHeight());
            g2.dispose();
          }
        };
        rp.setOpaque(true);
        return rp;
      }
    };
    frame.getRootPane().setBackground(Color.BLUE);
    frame.getLayeredPane().setBackground(Color.GREEN);
    frame.getContentPane().setBackground(Color.RED);
    ((JComponent)frame.getContentPane()).setOpaque(false);
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.setJMenuBar(createMenubar());
    frame.setSize(320, 240);
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
  }
}
</code></pre>

## コメント
- 選択状態を半透明にするテスト -- *aterai* 2010-01-09 (土) 23:08:42
    - `Windows7`での`WindowsLookAndFeel`でうまくいかない場合があるようなので、すこし修正。 -- *aterai* 2011-09-26 (月) 21:13:47
    - [JRootPaneの背景として画像を表示](http://terai.xrea.jp/Swing/RootPaneBackground.html)に移動

<!-- dummy comment line for breaking list -->
