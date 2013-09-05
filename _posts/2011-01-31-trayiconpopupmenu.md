---
layout: post
title: TrayIconでJPopupMenuを使用する
category: swing
folder: TrayIconPopupMenu
tags: [TrayIcon, JPopupMenu, JDialog]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-01-31

## TrayIconでJPopupMenuを使用する
`TrayIcon`をクリックして`JPopupMenu`を表示します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TUZUBCgOGJI/AAAAAAAAA0A/Ox5g3HoxmoI/s800/TrayIconPopupMenu.png)

### サンプルコード
<pre class="prettyprint"><code>final SystemTray tray  = SystemTray.getSystemTray();
final Image image      = new ImageIcon(getClass().getResource("16x16.png")).getImage();
final TrayIcon icon    = new TrayIcon(image, "TRAY", null);
final JPopupMenu popup = new JPopupMenu();
final JDialog dummy    = new JDialog();
// This code is inspired from:
// http://weblogs.java.net/blog/alexfromsun/archive/2008/02/jtrayicon_updat.html
dummy.setUndecorated(true);
popup.addPopupMenuListener(new PopupMenuListener() {
  @Override public void popupMenuWillBecomeVisible(PopupMenuEvent e) {}
  @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {
    dummy.setVisible(false);
  }
  @Override public void popupMenuCanceled(PopupMenuEvent e) {
    dummy.setVisible(false);
  }
});
icon.addMouseListener(new MouseAdapter() {
  private void showJPopupMenu(MouseEvent e) {
    if(e.isPopupTrigger()) {
      Point p = adjustPopupLocation(popup, e.getX(), e.getY());
      dummy.setLocation(p);
      dummy.setVisible(true);
      popup.show(dummy, 0, 0);
    }
  }
  @Override public void mouseReleased(MouseEvent e) {
    showJPopupMenu(e);
  }
  @Override public void mousePressed(MouseEvent e) {
    showJPopupMenu(e);
  }
});
</code></pre>

### 解説
`Java 1.6.0`では、`TrayIcon`には`java.awt.PopupMenu`しか使用できないので、`setUndecorated(true)`かつ、サイズが`0x0`の`JDialog`を適当な位置(`TrayIcon`のクリックで`JPopupMenu`が開いたように見える場所)に配置し、これを親にして`javax.swing.JPopupMenu`を表示しています。

- - - -
`PopupMenu`ではなく、`JPopupMenu`が使用できるので、以下のようなことが可能になります。

- `JCheckBoxMenuItem`、`JRadioButtonMenuItem`の使用
- `LookAndFeel`の変更

<!-- dummy comment line for breaking list -->

- - - -
このサンプルでは、`JPopupMenu#adjustPopupLocationToFitScreen(...)`メソッドを改変して、`SystemTray`の位置によって`JPopupMenu`が画面外にはみ出さないように調整しています。

<pre class="prettyprint"><code>//Copied from JPopupMenu.java: JPopupMenu#adjustPopupLocationToFitScreen(...)
private static Point adjustPopupLocation(JPopupMenu popup, int xposition, int yposition) {
  Point p = new Point(xposition, yposition);
  if (GraphicsEnvironment.isHeadless()) return p;

  Rectangle screenBounds;
  GraphicsConfiguration gc = null;
  // Try to find GraphicsConfiguration, that includes mouse pointer position
  for (GraphicsDevice gd: GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices()) {
    if (gd.getType() == GraphicsDevice.TYPE_RASTER_SCREEN) {
      GraphicsConfiguration dgc = gd.getDefaultConfiguration();
      if (dgc.getBounds().contains(p)) {
        gc = dgc;
        break;
      }
    }
  }

  // If not found and popup have invoker, ask invoker about his gc
  if (gc == null &amp;&amp; popup.getInvoker() != null) {
    gc = popup.getInvoker().getGraphicsConfiguration();
  }

  if (gc != null) {
    // If we have GraphicsConfiguration use it to get
    // screen bounds
    screenBounds = gc.getBounds();
  } else {
    // If we don't have GraphicsConfiguration use primary screen
    screenBounds = new Rectangle(Toolkit.getDefaultToolkit().getScreenSize());
  }

  Dimension size = popup.getPreferredSize();

  // Use long variables to prevent overflow
  long pw = (long) p.x + (long) size.width;
  long ph = (long) p.y + (long) size.height;

  if (pw &gt; screenBounds.x + screenBounds.width)  p.x -= size.width;
  if (ph &gt; screenBounds.y + screenBounds.height) p.y -= size.height;

  // Change is made to the desired (X,Y) values, when the
  // PopupMenu is too tall OR too wide for the screen
  if (p.x &lt; screenBounds.x) p.x = screenBounds.x;
  if (p.y &lt; screenBounds.y) p.y = screenBounds.y;

  return p;
}
</code></pre>

### 参考リンク
- [JTrayIcon update | Java.net](http://weblogs.java.net/blog/alexfromsun/archive/2008/02/jtrayicon_updat.html)
    - [Swinghelper: Subversion: JXTrayIcon.java — Java.net](http://java.net/projects/swinghelper/sources/svn/content/trunk/src/java/org/jdesktop/swinghelper/tray/JXTrayIcon.java)
- [How to Use the System Tray (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Other Swing Features)](http://docs.oracle.com/javase/tutorial/uiswing/misc/systemtray.html)
- [Bug ID: 6285881 JTrayIcon: support Swing JPopupMenus for tray icons](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6285881)
- [Bug ID: 6453521 TrayIcon should support transparency](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6453521)

<!-- dummy comment line for breaking list -->

### コメント
- ソースを上げ忘れていたのを修正orz。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-02-02 (水) 19:07:51
- `JRE1.6.0u3`で`2`度連続で右クリックすると`ClassCastException`起きちゃうんですよね・・・`BugParade`でも見つけらんなかったです -- [sawshun](http://terai.xrea.jp/sawshun.html) 2011-10-25 (火) 18:45:38
    - どうもです。こちらでも`WindowsXP`+`Java6u3`の環境で、`TrayIcon`上で右クリックを繰り返すと、`ClassCastException: java.awt.TrayIcon cannot be cast to java.awt.Component`が発生するのを確認しました。`bugs.sun.com`を調べたら、`6u10`で修正された [Bug ID: 6583251 One more ClassCastException in Swing with TrayIcon](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6583251)がそれっぽい気がします。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-10-26 (水) 00:56:41
- 情報ありがとうございます・・・`u10`か・・・`SynthUI`がらみの大きなパッケージ変更がイやで古代の`Ver`を利用しているのでちょっと工夫してみます -- [sawshun](http://terai.xrea.jp/sawshun.html) 2011-10-27 (木) 10:45:59

<!-- dummy comment line for breaking list -->
