---
layout: post
title: SystemTrayにアイコンを表示
category: swing
folder: SystemTray
tags: [SystemTray, Icon]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-03-05

## SystemTrayにアイコンを表示
`JDK 6`で追加された機能を使って、`SystemTray`にアイコンを表示します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTUJeisovI/AAAAAAAAAlk/zvAoP96Ntcs/s800/SystemTray.png)

### サンプルコード
<pre class="prettyprint"><code>public MainPanel(final JFrame frame) {
  super();
  if(!SystemTray.isSupported()) {
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    return;
  }
  frame.addWindowStateListener(new WindowAdapter() {
    @Override public void windowIconified(WindowEvent e) {
      frame.dispose();
    }
  });
  final SystemTray tray = SystemTray.getSystemTray();
  final Image image     = new ImageIcon(
                            getClass().getResource("16x16.png")).getImage();
  final PopupMenu popup = new PopupMenu();
  final TrayIcon icon   = new TrayIcon(image, "TRAY", popup);

  MenuItem item1 = new MenuItem("OPEN");
  item1.addActionListener(new ActionListener() {
    @Override public void actionPerformed(ActionEvent e) {
      frame.setVisible(true);
    }
  });
  MenuItem item2 = new MenuItem("EXIT");
  item2.addActionListener(new ActionListener() {
    @Override public void actionPerformed(ActionEvent e) {
      tray.remove(icon);
      frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      frame.dispose();
      //System.exit(0);
    }
  });
  popup.add(item1);
  popup.add(item2);

  try{
    tray.add(icon);
  }catch(AWTException e) {
    e.printStackTrace();
  }
}
</code></pre>

### 解説
トレイアイコンでは、`JPopupMenu`ではなく、`PopupMenu`や`MenuItem`を使用します。

上記のサンプルでは、フレームがアイコン化(最小化)されたときにタスクバーの表示を消して、システムトレイにアイコンだけ表示したいので、初期状態を`frame.setDefaultCloseOperation(WindowConstants.HIDE_ON_CLOSE);`にしておき、アイコン化された場合でも、`frame.dispose();`するようにしています。

実際に`VM`を終了する場合は、表示可能なウィンドウをすべて破棄して(`frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);`)、システムトレイからも`tray.remove(icon);`してアイコンを取り除けばいいようです。

### 参考リンク
- [TrayIconのアニメーション](http://terai.xrea.jp/Swing/AnimatedTrayIcon.html)
- [TrayIconのダブルクリック](http://terai.xrea.jp/Swing/ClickTrayIcon.html)

<!-- dummy comment line for breaking list -->

### コメント
- `Ubuntu`だと通知スペースに表示されるのですが、背景色や位置がどうもうまくいっていないようです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-05-08 (火) 20:23:38
    - 位置は以下みたいにすれば適当に補正できそうですが、背景色はどうしたらいいんだろう？ `g.setColor(UIManager.getColor("Panel.background"));g.fillRect(0,0,d.width,d.height);`とかするのは酷いか…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-05-08 (火) 21:11:09

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>SystemTray tray = SystemTray.getSystemTray();
Dimension d = tray.getTrayIconSize();
//Image image = new ImageIcon(getClass().getResource("16x16.png")).getImage();
BufferedImage image = new BufferedImage(d.width,d.height,BufferedImage.TYPE_INT_ARGB);
ImageIcon i = new ImageIcon(getClass().getResource("16x16.png"));
Graphics g = image.createGraphics();
i.paintIcon(null,g,(d.width-i.getIconWidth())/2,(d.height-i.getIconWidth())/2);
g.dispose();
PopupMenu popup = new PopupMenu();
TrayIcon icon   = new TrayIcon(image, "TRAY", popup);
</code></pre>

    - `g.setBackground(new Color(0,0,0,0));g.clearRect(0,0,d.width,d.height);`とかしても変化無し。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-05-09 (水) 13:54:25
- メモ: [TrayIcon does not support 8-bit alpha channel in Windows XP](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6707273) -- [aterai](http://terai.xrea.jp/aterai.html) 2009-12-08 (火) 09:28:46
- タスクバーのアイコンがなくなりシステムトレイのアイコンだけになりませんか？ --  2010-03-05 (金) 21:05:36
    - `Windows`でしか試していませんが、`JFrame`の代わりに、`JDialog`を使えばタスクバーには何も表示されないと思います(質問の意味を取り違えてなければいいのですが……)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-03-06 (土) 23:22:39
- 消したいのはタイトルバーではなくてシステムトレイの隣のタスクバーアイコンです。文字で伝えるのは難しいですね。 --  2010-03-08 (月) 17:28:43
- スクリーンショットで`JST`システムトレイとタスクバーにあるやつです --  2010-03-08 (月) 17:30:21
    - `JFrame`の代わりに、`JWindow`を使うのはどうでしょうか。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-03-09 (火) 16:26:47
    - もしくは、[JFrameのアイコンを非表示](http://terai.xrea.jp/Swing/DisableDefaultIcon.html)のように透明なアイコンを設定する(クリックすると反応してしまいますが…)とか。 -- [aterai](http://terai.xrea.jp/aterai.html)

<!-- dummy comment line for breaking list -->
