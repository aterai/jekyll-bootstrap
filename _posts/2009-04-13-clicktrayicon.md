---
layout: post
category: swing
folder: ClickTrayIcon
title: TrayIconのダブルクリック
tags: [TrayIcon, SystemTray, MouseListener, JFrame]
author: aterai
pubdate: 2009-04-13T14:23:01+09:00
description: TrayIconをダブルクリックした場合フレームを表示、シングルクリックした場合はフレームを前面に表示します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJK3dhHYI/AAAAAAAAAT8/1MUtk0Z-NQU/s800/ClickTrayIcon.png
comments: true
---
## 概要
`TrayIcon`をダブルクリックした場合フレームを表示、シングルクリックした場合はフレームを前面に表示します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJK3dhHYI/AAAAAAAAAT8/1MUtk0Z-NQU/s800/ClickTrayIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>Image image = new BufferedImage(16, 16, BufferedImage.TYPE_INT_ARGB);
Graphics g = image.getGraphics();
new StarIcon().paintIcon(null, g, 0, 0);
g.dispose();
final SystemTray tray = SystemTray.getSystemTray();
PopupMenu popup       = new PopupMenu();
MenuItem open         = new MenuItem("Option");
MenuItem exit         = new MenuItem("Exit");
final TrayIcon icon   = new TrayIcon(image, "Click Test", popup);
popup.add(open);
popup.add(exit);
icon.addMouseListener(new MouseAdapter() {
  @Override public void mouseClicked(MouseEvent e) {
    if (e.getButton() == MouseEvent.BUTTON1 &amp;&amp; e.getClickCount() == 2) {
      frame.setVisible(true);
    } else if (frame.isVisible()) {
      frame.setExtendedState(Frame.NORMAL);
      frame.toFront();
    }
  }
});
open.addActionListener(new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    frame.setVisible(true);
  }
});
exit.addActionListener(new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    tray.remove(icon);
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    // frame.dispose();
    frame.getToolkit().getSystemEventQueue().postEvent(
      new WindowEvent(frame, WindowEvent.WINDOW_CLOSING));
  }
});
try {
  tray.add(icon);
} catch (AWTException e) {
  e.printStackTrace();
}
</code></pre>

## 解説
`TrayIcon`に`MouseListener`を追加し、マウスでダブルクリックした場合の動作を変更します。

- 左ボタンでダブルクリック
    - フレームが非表示の場合は再表示
- 左ボタンでシングルクリック
    - フレームが表示、または最小化されている場合、元のサイズに戻して最前面に表示
    - フレームが非表示の場合はなにもしない
- 中ボタンでクリック
    - なにもしない
- 右ボタンでクリック
    - ポップアップメニューを表示

<!-- dummy comment line for breaking list -->

## 参考リンク
- [SystemTrayにアイコンを表示](https://ateraimemo.com/Swing/SystemTray.html)
- [TrayIconのアニメーション](https://ateraimemo.com/Swing/AnimatedTrayIcon.html)

<!-- dummy comment line for breaking list -->

## コメント
