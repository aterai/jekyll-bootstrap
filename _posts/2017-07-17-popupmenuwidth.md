---
layout: post
category: swing
folder: PopupMenuWidth
title: JPopupMenuの最小幅を設定する
tags: [JPopupMenu, JMenu, JMenuItem, LayoutManager]
author: aterai
pubdate: 2017-07-17T23:29:21+09:00
description: JPopupMenuに下限となる最小幅を固定値で設定します。
image: https://drive.google.com/uc?id=1SYHBxJoZ2kPCmF9HQVhg0esnQTnpSZpq5w
comments: true
---
## 概要
`JPopupMenu`に下限となる最小幅を固定値で設定します。

{% download https://drive.google.com/uc?id=1SYHBxJoZ2kPCmF9HQVhg0esnQTnpSZpq5w %}

## サンプルコード
<pre class="prettyprint"><code>menu = new JMenu("BoxHStrut");
menu.add(Box.createHorizontalStrut(200));
</code></pre>

## 解説
- `Default`
    - `JMenu`に配置されたコンポーネントの最も大きな推奨サイズの幅から`JPopupMenu`の幅が決まる
- `BoxHStrut`
    - `Box.createHorizontalStrut(200)`で高さ`0`で任意の幅のコンポーネントを作成して`JMenu`に配置
    - この`Box`の幅が`JPopupMenu`の最小幅になる
    - この`Box`は`MenuElement`インタフェースに適合しないので`JMenu#getSubElements()`などには含まれない
        - [JMenu#getSubElements() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JMenu.html#getSubElements--)
- `Override`
    - `JMenu`に配置する`JMenuItem`の`getPreferredSize()`メソッドをオーバーライドして、任意の幅を返すように設定
    - この`JMenuItem`の幅が`JPopupMenu`の最小幅になる
- `Layout`
    - `JMenu`が使用する`JPopupMenu`のレイアウトを変更
    - `DefaultMenuLayout#preferredLayoutSize(...)`メソッドをオーバーライドして、任意の幅を返すように設定
        
        <pre class="prettyprint"><code>popup.setLayout(new DefaultMenuLayout(popup, BoxLayout.Y_AXIS) {
          @Override public Dimension preferredLayoutSize(Container target) {
            Dimension d = super.preferredLayoutSize(target);
            d.width = Math.max(200, d.width);
            return d;
          }
        });
</code></pre>
- `Html`
    - 余白などを`0`にし、幅を設定した`<table>`タグで装飾した文字列を使用する`JMenuItem`を使用
        - `new JMenuItem("<html><table cellpadding='0' cellspacing='0' style='width:200'>...")`
    - 文字列自体の幅が`<table>`で指定した幅になるので、`Accelerator`などが存在するとその幅も追加される
    - `html`タグを使用するので`Mnemonic`が表示できない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DefaultMenuLayout (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/DefaultMenuLayout.html)

<!-- dummy comment line for breaking list -->

## コメント
