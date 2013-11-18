---
layout: post
title: TrayIconのダブルクリック
category: swing
folder: ClickTrayIcon
tags: [TrayIcon, SystemTray, MouseListener, JFrame]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-04-13

## TrayIconのダブルクリック
`TrayIcon`をダブルクリックした場合フレームを表示、シングルクリックした場合はフレームを前面に表示します。

{% download %}

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJK3dhHYI/AAAAAAAAAT8/1MUtk0Z-NQU/s800/ClickTrayIcon.png)

### サンプルコード
<pre class="prettyprint"><code>Image image = new BufferedImage(16,16,BufferedImage.TYPE_INT_ARGB);
new StarIcon().paintIcon(null, image.getGraphics(), 0, 0);
final SystemTray tray = SystemTray.getSystemTray();
PopupMenu popup       = new PopupMenu();
MenuItem open         = new MenuItem("Option");
MenuItem exit         = new MenuItem("Exit");
final TrayIcon icon   = new TrayIcon(image, "Click Test", popup);
popup.add(open);
popup.add(exit);
icon.addMouseListener(new MouseAdapter() {
  @Override public void mouseClicked(MouseEvent e) {
    if(e.getButton()==MouseEvent.BUTTON1 &amp;&amp; e.getClickCount()==2) {
      frame.setVisible(true);
    }else if(frame.isVisible()) {
      frame.setExtendedState(JFrame.NORMAL);
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
    //frame.dispose();
    frame.getToolkit().getSystemEventQueue().postEvent(
      new WindowEvent(frame, WindowEvent.WINDOW_CLOSING));
  }
});
try{
  tray.add(icon);
}catch(AWTException e) {
  e.printStackTrace();
}
</code></pre>

### 解説
`TrayIcon`にマウスリスナーを追加してマウスでダブルクリックした場合の動作を変更します。

- 左ボタンをダブルクリック
    - フレームが非表示の場合は、再表示
- 左ボタンをシングルクリック
    - フレームが表示、または最小化されている場合、元のサイズに戻して最前面に表示
    - フレームが非表示の場合は、なにもしない

<!-- dummy comment line for breaking list -->

- 中ボタンのクリック
    - なにもしない

<!-- dummy comment line for breaking list -->

- 右ボタンのクリック
    - ポップアップメニューを表示

<!-- dummy comment line for breaking list -->

### 参考リンク
- [SystemTrayにアイコンを表示](http://terai.xrea.jp/Swing/SystemTray.html)
- [TrayIconのアニメーション](http://terai.xrea.jp/Swing/AnimatedTrayIcon.html)

<!-- dummy comment line for breaking list -->

### コメント
