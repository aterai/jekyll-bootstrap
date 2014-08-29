---
layout: post
title: Cursorのアニメーション
category: swing
folder: AnimatedCursor
tags: [Cursor, Animation]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-05-01

## Cursorのアニメーション
マウスカーソルをアニメーションさせます。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTHkbNXdwI/AAAAAAAAARY/RzDAT8xyR3c/s800/AnimatedCursor.png %}

### サンプルコード
<pre class="prettyprint"><code>list[0] = tk.createCustomCursor(tk.createImage(url00), p, "00");
list[1] = tk.createCustomCursor(tk.createImage(url01), p, "01");
list[2] = tk.createCustomCursor(tk.createImage(url02), p, "02");
setCursor(list[0]);
animator = new javax.swing.Timer(100, new ActionListener() {
  private int count = 0;
  @Override public void actionPerformed(ActionEvent e) {
    setCursor(list[count]);
    count = (count + 1+ list.length) % list.length;
  }
});
JButton button = new JButton(new AbstractAction("スタート") {
  @Override public void actionPerformed(ActionEvent e) {
    JButton button = (JButton)e.getSource();
    if(animator.isRunning()) {
      button.setText("スタート");
      animator.stop();
    }else{
      button.setText("ストップ");
      animator.start();
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、ボタンをクリックすると、パネル上にあるカーソルがアニメーションするようになっています。`3`枚の透過`png`ファイルをコマにして、`Timer`で順番にこれを切り替えています。

各コマは、[ぶーん(通常の選択.ani、VIPポインタ)](http://www11.atwiki.jp/vippointer/pages/54.html)から、[ANIめーかー](http://www.vector.co.jp/soft/win95/amuse/se195017.html)を使って生成しています。

### 参考リンク
- [VIPポインタ@Wiki - トップページ](http://www11.atwiki.jp/vippointer/)
- [ANIめーかー(Windows95/98/Me/アミューズメント)](http://www.vector.co.jp/soft/win95/amuse/se195017.html)
- [Cursorオブジェクトの生成](http://terai.xrea.jp/Swing/CustomCursor.html)
- [oreilly.co.jp -- Online Catalog: Java Swing Hacks](http://www.oreilly.co.jp/books/4873112788/download.html)

<!-- dummy comment line for breaking list -->

### コメント
- `Cursor`に用いる`png`ファイルは、フルカラー(`24`ビット)ではなく`256`色にしておかないと、うまく透過できないようです。もしかしたら自分の`PC`の画面の色が`16`ビットになっているせいかもしれません。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-07-11 (火) 12:41:59
    - `32`ビットにしてもだめみたいです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-07-25 (火) 16:53:29
    - 追記: `JDK 6`なら、フルカラーでも問題なく透過できるようです。[Bug ID: 6388546 PNG with transparent background doesn't render correctly](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6388546) -- [aterai](http://terai.xrea.jp/aterai.html) 2008-07-28 (月) 16:27:56
- `Windows XP`で、カーソルを`Animated GIF`ファイルから生成(`Toolkit.getDefaultToolkit().createCustomCursor`)しようとすると、 ~~落ちる？~~ `Ubuntu`だと、アニメーションはしないけど、ちゃんと画像がカーソルになる。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-05-08 (火) 14:25:37
    - デッドロック？ -- [aterai](http://terai.xrea.jp/aterai.html) 2008-05-07 (水) 19:38:38
    - メモ: [Bug ID: 4343270 Toolkit.createCustomCursor() hangs the VM under Win NT](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4343270)、[Bug ID: 4939855 Please allow Toolkit.createCustomCursor() to accept multi-frame images](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4939855) -- [aterai](http://terai.xrea.jp/aterai.html) 2008-09-01 (月) 23:18:57
    - よくみたら、[Toolkit#createCustomCursor](http://docs.oracle.com/javase/jp/6/api/java/awt/Toolkit.html#createCustomCursor%28java.awt.Image,%20java.awt.Point,%20java.lang.String%29)に、「マルチフレームイメージは無効で、このメソッドがハングすることがあります。」と注意書きがあった(`1.4.2`のドキュメントから？)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-01-19 (火) 17:03:17

<!-- dummy comment line for breaking list -->

