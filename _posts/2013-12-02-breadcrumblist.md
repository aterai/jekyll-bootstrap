---
layout: post
title: FlowLayoutでボタンを重ねてパンくずリストを作成する
category: swing
folder: BreadcrumbList
tags: [FlowLayout, JRadioButton, JPanel, Shape, Icon]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-12-02

## FlowLayoutでボタンを重ねてパンくずリストを作成する
`FlowLayout`の水平間隔をマイナスにして、`JRadioButton`を重ねて表示し、パンくずリスト風のコンポーネントを作成します。


{% download https://lh5.googleusercontent.com/-aKK_2LaPfVQ/UpsqWSS4lUI/AAAAAAAAB7c/VSzPRuRu3IY/s800/BreadcrumbList.png %}

### サンプルコード
<pre class="prettyprint"><code>private static JComponent makeBreadcrumbList(int overlap, List&lt;String&gt; list) {
  JPanel p = new JPanel(new FlowLayout(FlowLayout.LEADING, -overlap, 0));
  p.setBorder(BorderFactory.createEmptyBorder(4, overlap+4, 4, 4));
  p.setOpaque(false);
  ButtonGroup bg = new ButtonGroup();
  for(String title: list) {
    AbstractButton b = makeButton(title, Color.PINK);
    p.add(b);
    bg.add(b);
  }
  return p;
}
</code></pre>

### 解説
上記のサンプルでは、指定したピクセル分だけ重なるように、`FlowLayout`の水平間隔にマイナスの値を指定しています。このため、左側の`JRadioButton`の下に右側の`JRadioButton`が配置されている状態になっています。各`JRadioButton`自体は重なっていますが、描画やマウスクリックなどは重ならないよう、以下のような設定を追加しています。

- 描画
    - 矢羽型のアイコンを設定、このアイコン以外は、`setContentAreaFilled(false);`などで透明化
- マウスクリック
    - `JRadioButton#contains(...)`をオーバーライドして、上記の矢羽図形の外では反応しないよう設定

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JRadioButtonを使ってToggleButtonBarを作成](http://terai.xrea.jp/Swing/ToggleButtonBar.html)
- [JMenuItemの内部にJButtonを配置する](http://terai.xrea.jp/Swing/ButtonsInMenuItem.html)
    - 前後のコンポーネントのフチを共通化して(`1px`だけ重ねる)、`JLayer`でそのフォーカスを描画するサンプル

<!-- dummy comment line for breaking list -->

### コメント
