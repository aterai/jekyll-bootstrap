---
layout: post
category: swing
folder: TextOverflowFadeTabbedPane
title: JTabbedPaneのタブ文字列のあふれをフェードアウト効果に変更する
tags: [JTabbedPane, JLabel]
author: aterai
pubdate: 2018-12-24T18:32:17+09:00
description: JTabbedPaneのタブ文字列があふれる場合、…記号で省略するのではなく、端付近の文字をフェードアウト効果で透明化します。
image: https://drive.google.com/uc?id=1HfDHTs2CpOVyU6avrOnjFGJrLoyN6veqSg
hreflang:
    href: https://java-swing-tips.blogspot.com/2018/12/fade-out-jtabbedpane-tab-title-on.html
    lang: en
comments: true
---
## 概要
`JTabbedPane`のタブ文字列があふれる場合、`…`記号で省略するのではなく、端付近の文字をフェードアウト効果で透明化します。

{% download https://drive.google.com/uc?id=1HfDHTs2CpOVyU6avrOnjFGJrLoyN6veqSg %}

## サンプルコード
<pre class="prettyprint"><code>class TextOverflowFadeTabbedPane extends ClippedTitleTabbedPane {
  @Override public void insertTab(
        String title, Icon icon, Component component, String tip, int index) {
    super.insertTab(title, icon, component, Objects.toString(tip, title), index);
    JPanel p = new JPanel(new BorderLayout(2, 0));
    p.setOpaque(false);
    p.add(new JLabel(icon), BorderLayout.WEST);
    p.add(new TextOverflowFadeLabel(title));
    setTabComponentAt(index, p);
  }
}
</code></pre>

## 解説
- 上: デフォルトの`JLabel`を使用してタブタイトル文字列を表示
    - [JTabbedPaneのタブを等幅にしてタイトルをクリップ](https://ateraimemo.com/Swing/ClippedTitleTab.html)を使用してタブ幅を等幅にし、あふれは省略記号`…`で置換
- 下: `JTabbedPane`のタブタイトル文字列を表示する`JLabel`をフェードアウト効果であふれを表現する`TextOverflowFadeLabel`に変更
    - `TextOverflowFadeLabel`は、[JLabelで文字列のあふれをフェードアウト効果に変更する](https://ateraimemo.com/Swing/TextOverflowFadeLabel.html)で作成したものと同一
    - `TextOverflowFadeLabel`は`Icon`表示などに未対応のため、`JTabbedPane#setTabComponentAt(...)`で設定するタブタイトル用のコンポーネントには`Icon`のみ表示する`JLabel`と文字列のみ表示する`TextOverflowFadeLabel`の`2`つを`JPanel`に配置して代用

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JLabelで文字列のあふれをフェードアウト効果に変更する](https://ateraimemo.com/Swing/TextOverflowFadeLabel.html)
- [JTabbedPaneのタブを等幅にしてタイトルをクリップ](https://ateraimemo.com/Swing/ClippedTitleTab.html)

<!-- dummy comment line for breaking list -->

## コメント
