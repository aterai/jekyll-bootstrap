---
layout: post
title: TrayIconのアニメーション
category: swing
folder: AnimatedTrayIcon
tags: [SystemTray, Icon, Animation]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-02-05

## TrayIconのアニメーション
`SystemTray`に追加したアイコン(`JDK 6`以上)をアニメーションさせます。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTHtWabBgI/AAAAAAAAARk/J0ExgthCnn4/s800/AnimatedTrayIcon.png)

### サンプルコード
<pre class="prettyprint"><code>final TrayIcon icon = new TrayIcon(imglist[0], "TRAY", popup);
animator = new javax.swing.Timer(100, new ActionListener() {
  private int idx = 0;
  @Override public void actionPerformed(ActionEvent e) {
    icon.setImage(imglist[idx]);
    idx = (idx&lt;imglist.length-1)?idx+1:0;
  }
});
</code></pre>

### 解説
`16*16`の画像を`3`パターン用意し、これを`JDK 6`で追加された`TrayIcon#setImage(Image)`メソッドを使って切り替えることでアニメーションしています。

### 参考リンク
- [SystemTrayにアイコンを表示](http://terai.xrea.jp/Swing/SystemTray.html)
- [TrayIconのダブルクリック](http://terai.xrea.jp/Swing/ClickTrayIcon.html)

<!-- dummy comment line for breaking list -->

### コメント
- `animated gif`を使うほうが簡単だと思うのですが、作った`Gif`が悪いのか、環境のせいなのか、残像がでてしまいます。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-02-05 (月) 19:00:34
    - メモ: [Bug ID: 6453582 Animation gif too fast](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6453582) -- [aterai](http://terai.xrea.jp/aterai.html) 2007-04-19 (木) 21:11:50
    - 上のバグ？でウェイトが効かずに残像が残っていたのではなく、前のコマがそのまま残して透過色(背景色)でクリアしないタイプ？のアニメ`GIF`になっていたようです。[Giam](http://homepage3.nifty.com/furumizo/giamd.htm)を使って、全コマの消去方法を「背景色で塗りつぶす」に変更したファイルを使用すると、正常に描画されるようになりました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-04-19 (木) 22:04:52

<!-- dummy comment line for breaking list -->

