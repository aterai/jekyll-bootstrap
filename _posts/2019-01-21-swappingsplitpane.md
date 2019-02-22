---
layout: post
category: swing
folder: SwappingSplitPane
title: JSplitPaneに設定した子コンポーネントの位置を入れ替える
tags: [JSplitPane]
author: aterai
pubdate: 2019-01-21T00:29:34+09:00
description: JSplitPaneに設定した子コンポーネントの位置と余分なスペースの配分率を入れ替えます。
image: https://drive.google.com/uc?export=view&id=1TMNOHO7KVS63zeFEW4xasYw5TX-ZNqTL9w
hreflang:
    href: https://java-swing-tips.blogspot.com/2019/01/swap-position-of-child-components-in.html
    lang: en
comments: true
---
## 概要
`JSplitPane`に設定した子コンポーネントの位置と余分なスペースの配分率を入れ替えます。

{% download https://drive.google.com/uc?export=view&id=1TMNOHO7KVS63zeFEW4xasYw5TX-ZNqTL9w %}

## サンプルコード
<pre class="prettyprint"><code>JButton button = new JButton("swap");
button.setFocusable(false);
button.addActionListener(e -&gt; {
  Component left = sp.getLeftComponent();
  Component right = sp.getRightComponent();

  // sp.removeAll(); // Divider is also removed
  sp.remove(left);
  sp.remove(right);
  // or:
  // sp.setLeftComponent(null);
  // sp.setRightComponent(null);

  sp.setLeftComponent(right);
  sp.setRightComponent(left);

  sp.setResizeWeight(1d - sp.getResizeWeight());
  if (check.isSelected()) {
    sp.setDividerLocation(sp.getDividerLocation());
  }
});
</code></pre>

## 解説
上記のサンプルでは、水平分割した`JSplitPane`の左右に配置したコンポーネントを入れ替え可能に設定しています。

- すでに`JSplitPane`に配置されているコンポーネントを別の位置に配置すると例外が発生するため、一旦`JSplitPane`から削除する必要がある
- `JSplitPane#removeAll()`を使用するとディバイダも削除されてしまう
- `JSplitPane#remove(Component)`、または`JSplitPane#setLeftComponent(null)`などで削除する
- ディバイダの位置を入れ替え前と同じ場所に保つ場合、`JSplitPane#setResizeWeight(...)`メソッドで余分なスペースの配分率の入れ替えと、`JSplitPane#setDividerLocation(...)`メソッドで位置の再設定が必要になる

<!-- dummy comment line for breaking list -->

- - - -
- `GridLayout`を設定した`JPanel`などの場合は、以下のように`Container#setComponentZOrder(...)`メソッドでコンポーネントの位置の入れ替えが可能
    - サンプルコードは、[JPanelに追加したコンポーネントの順序を変更する](https://ateraimemo.com/Swing/ComponentZOrder.html)に移動

<!-- dummy comment line for breaking list -->

## 参考リンク
- [swing - java: Problem with JSplitpane - Stack Overflow](https://stackoverflow.com/questions/4871874/java-problem-with-jsplitpane)
- [JPanelに追加したコンポーネントの順序を変更する](https://ateraimemo.com/Swing/ComponentZOrder.html)

<!-- dummy comment line for breaking list -->

## コメント
