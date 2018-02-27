---
layout: post
category: swing
folder: TranslucentPopupMenu
title: JPopupMenuを半透明にする
tags: [JPopupMenu, JMenuItem, JWindow, Translucent]
author: aterai
pubdate: 2012-02-27T14:25:17+09:00
description: JPopupMenu自体の背景を透明に設定し、別途そのpaintComponent(...)メソッドをオーバーライドして半透明の背景を描画します。
image: https://lh3.googleusercontent.com/-SKQis3B-SmY/T0dd531MovI/AAAAAAAABJk/fWIZIAeE3oE/s800/TranslucentPopupMenu.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2012/07/translucent-jpopupmenu.html
    lang: en
comments: true
---
## 概要
`JPopupMenu`自体の背景を透明に設定し、別途その`paintComponent(...)`メソッドをオーバーライドして半透明の背景を描画します。

{% download https://lh3.googleusercontent.com/-SKQis3B-SmY/T0dd531MovI/AAAAAAAABJk/fWIZIAeE3oE/s800/TranslucentPopupMenu.png %}

## サンプルコード
<pre class="prettyprint"><code>class TranslucentPopupMenu extends JPopupMenu {
  private static final Color ALPHA_ZERO = new Color(0x0, true);
  private static final Color POPUP_BACK = new Color(250, 250, 250, 200);
  private static final Color POPUP_LEFT = new Color(230, 230, 230, 200);
  private static final int LEFT_WIDTH = 24;
  @Override public boolean isOpaque() {
    return false;
  }
  @Override public void updateUI() {
    super.updateUI();
    if (UIManager.getBorder("PopupMenu.border") == null) {
      setBorder(new BorderUIResource(BorderFactory.createLineBorder(Color.GRAY)));
    }
  }
  @Override public JMenuItem add(JMenuItem menuItem) {
    menuItem.setOpaque(false);
    //menuItem.setBackground(ALPHA_ZERO);
    return super.add(menuItem);
  }
  @Override public void show(Component c, int x, int y) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        Window p = SwingUtilities.getWindowAncestor(TranslucentPopupMenu.this);
        if (p instanceof JWindow) {
          System.out.println("Heavy weight");
          JWindow w = (JWindow) p;
          w.setBackground(ALPHA_ZERO);
        } else {
          System.out.println("Light weight");
        }
      }
    });
    super.show(c, x, y);
  }
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setPaint(POPUP_LEFT);
    g2.fillRect(0, 0, LEFT_WIDTH, getHeight());
    g2.setPaint(POPUP_BACK);
    g2.fillRect(LEFT_WIDTH, 0, getWidth(), getHeight());
    g2.dispose();
    //super.paintComponent(g);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JPopupMenu`は`isOpaque()`メソッドをオーバーライド、`JMenuItem`は`setOpaque(false)`として、それぞれ透明に設定し、`JPopupMenu#paintComponent(...)`で、半透明の背景を描画しています。

`JPopupMenu`が親フレームの外にはみ出す場合は、`Heavyweight`の`JWindow`を使って`JPopupMenu`が表示されるので、`JWindow#setBackground(new Color(0x0, true))`で(`JDK 1.6.0_10`では、`com.sun.awt.AWTUtilities.setWindowOpaque(w, false)`)、`JPopupMenu#show(...)`が呼ばれるたびに、毎回(親フレームの透明度を引き継がないように？)`JWindow`自体を透明にしています。

- - - -
- メモ: `JPopupMenu`(ルート)が`Light weight`で、その`JMenu`から開く`JPopupMenu`(サブメニュー) が`Heavy weight`のときに半透明にならない
    - [JDK-7156657 Version 7 doesn't support translucent popup menus against a translucent window - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-7156657)
    - `JDK 1.7.0_06`などで修正された

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Translucent and Shaped Swing Windows | Java.net](http://today.java.net/pub/a/today/2008/03/18/translucent-and-shaped-swing-windows.html)
- [JMenuなどから開くPopupMenuを半透明化](https://ateraimemo.com/Swing/TranslucentSubMenu.html)

<!-- dummy comment line for breaking list -->

## コメント
- メモ: [JDK-7156657 Version 7 doesn't support translucent popup menus against a translucent window - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-7156657)、[jdk8/jdk8/jdk: changeset 5453:4acd0211f48b](http://hg.openjdk.java.net/jdk8/jdk8/jdk/rev/4acd0211f48b) -- *aterai* 2012-08-10 (金) 19:22:39
    - `JDK 1.7.0_06`で修正されている？ [Java™ SE Development Kit 7 Update 6 Bug Fixes](http://www.oracle.com/technetwork/java/javase/2col/7u6-bugfixes-1733378.html) -- *aterai* 2012-08-15 (水) 13:55:37

<!-- dummy comment line for breaking list -->
