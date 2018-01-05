---
layout: post
category: swing
folder: TranslucentFrameRepaint
title: JFrameの透明化と再描画
tags: [JFrame, JRootPane, Translucent, JPanel, JLabel, TexturePaint]
author: aterai
pubdate: 2011-10-24T15:53:52+09:00
description: 透明にしたJFrameに半透明のデジタル時計を配置し、文字更新による背景色の再描画をテストします。
image: https://lh4.googleusercontent.com/-ujoDf8eD4vE/TqLcC0f2CHI/AAAAAAAABD4/LHaXXW6HW1k/s800/TranslucentFrameRepaint.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2014/02/translucent-jframe-repaint.html
    lang: en
comments: true
---
## 概要
透明にした`JFrame`に半透明のデジタル時計を配置し、文字更新による背景色の再描画をテストします。

{% download https://lh4.googleusercontent.com/-ujoDf8eD4vE/TqLcC0f2CHI/AAAAAAAABD4/LHaXXW6HW1k/s800/TranslucentFrameRepaint.png %}

## サンプルコード
<pre class="prettyprint"><code>private final SimpleDateFormat df = new SimpleDateFormat("HH:mm:ss");
private final JLabel label = new JLabel(df.format(new Date()));
private final Timer timer = new Timer(1000, new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    label.setText(df.format(new Date()));
    Container parent = SwingUtilities.getUnwrappedParent(label);
    if (parent != null &amp;&amp; parent.isOpaque()) {
      repaintWindowAncestor(label);
    }
  }
});
private void repaintWindowAncestor(JComponent c) {
  JRootPane root = c.getRootPane();
  if (root == null) {
    return;
  }
  Rectangle r = SwingUtilities.convertRectangle(c, c.getBounds(), root);
  root.repaint(r.x, r.y, r.width, r.height);
}
</code></pre>

## 解説
上記のサンプルでは、実際は`JFrame`が半透明ではなく、以下のように透明にした`JFrame`に、半透明の`JPanel`を追加、さらにその子として一秒ごとに文字列が変化する`JLabel`(時計)を配置しています。

- `JFrame`
    - 透明
        
        <pre class="prettyprint"><code>com.sun.awt.AWTUtilities.setWindowOpaque(frame, false); // JDK 1.6.0
        frame.setBackground(new Color(0x0, true)); // JDK 1.7.0以降
</code></pre>
    - `Window#setOpacity(...)`(または`JDK 1.6.0`で`AWTUtilities.setWindowOpacity(...)`)は、子コンポーネントを含めてすべて半透明になるので、このサンプルでは使用していない

<!-- dummy comment line for breaking list -->

- `JPanel`
    - `frame.getContentPane().add(panel)`で追加
    - 半透明(二種類)
        - `setOpaque(true)`+半透明のアルファ成分をもつ色を`setBackground()`で設定
        - `JPanel`が`setOpaque(true)`なので、`ContentPane`から再描画しないと、`JPanel`に設定した半透明の背景色が重複して上書きされる(色が濃くなる)
        - `setOpaque(false)`+`paintComponent()`をオーバーライドして背景画像などを描画

<!-- dummy comment line for breaking list -->

- `JLabel`
    - `panel.add(label)`で追加
    - 一秒ごとに文字列を変更する時計
    - `setOpaque(false)`で背景は透明

<!-- dummy comment line for breaking list -->

## 参考リンク
- [江戸の文様（和風素材・デスクトップ壁紙）](http://www.viva-edo.com/komon/edokomon.html)
- ~~[ユアネーム・7セグ・12セグフォント大全集](http://www.yourname.jp/soft/digitalfonts-20090306.shtml)~~

<!-- dummy comment line for breaking list -->

## コメント
- フォントをデジタル時計ぽいものに変更。 -- *aterai* 2012-02-10 (金) 17:35:12
    - スクリーンショットは入れ替えるのが面倒なので、古いフォントのまま。 -- *aterai* 2012-04-17 (火) 17:26:14

<!-- dummy comment line for breaking list -->
