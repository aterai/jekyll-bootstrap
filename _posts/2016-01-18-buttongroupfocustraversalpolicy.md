---
layout: post
category: swing
folder: ButtonGroupFocusTraversalPolicy
title: ButtonGroup内で最初にフォーカスを取得するJRadioButtonを変更する
tags: [ButtonGroup, FocusTraversalPolicy, JRadioButton, Focus]
author: aterai
pubdate: 2016-01-18T00:09:46+09:00
description: Tabキーによるフォーカス移動が発生した場合、ButtonGroup内で現在選択されているJRadioButtonにフォーカスが移動するよう設定します。
image: https://lh3.googleusercontent.com/-r6C4rorBCYw/Vpuu38No8lI/AAAAAAAAOLc/6xa7VoLpsWI/s800-Ic42/ButtonGroupFocusTraversalPolicy.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2016/05/the-jradiobutton-that-is-currently_10.html
    lang: en
comments: true
---
## 概要
<kbd>Tab</kbd>キーによるフォーカス移動が発生した場合、`ButtonGroup`内で現在選択されている`JRadioButton`にフォーカスが移動するよう設定します。

{% download https://lh3.googleusercontent.com/-r6C4rorBCYw/Vpuu38No8lI/AAAAAAAAOLc/6xa7VoLpsWI/s800-Ic42/ButtonGroupFocusTraversalPolicy.png %}

## サンプルコード
<pre class="prettyprint"><code>buttons.setFocusTraversalPolicyProvider(true);
buttons.setFocusTraversalPolicy(new LayoutFocusTraversalPolicy() {
  @Override public Component getDefaultComponent(Container focusCycleRoot) {
    return Stream.of(focusCycleRoot.getComponents())
                 .filter(c -&gt; ((JRadioButton) c).getModel().equals(selection))
                 .findFirst().orElse(super.getDefaultComponent(focusCycleRoot));
  }
});
</code></pre>

## 解説
- `Default`
    - ~~デフォルトの`LayoutFocusTraversalPolicy`では、`JRadioButton`の選択状態には無関係に、レイアウト内のグループ先頭にある`JRadioButton`にフォーカスが移動する~~
    - [JDK-8033699 Incorrect radio button behavior - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8033699)で修正済みで、デフォルトで以下と同じ動作をするようになった
- `FocusTraversalPolicy`
    - `JRadioButton`を配置したパネルに`getDefaultComponent(...)`メソッドをオーバーライドした`FocusTraversalPolicy`を設定し、現在選択されている`JRadioButton`が存在する場合は、それにフォーカスを移動する
    - パネルに設定した`FocusTraversalPolicy`を有効にするために、`JPanel#setFocusTraversalPolicyProvider(true);`を設定する必要がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - Get the focus in a ButtonGroup of JRadioButtons to go to the currently selected item instead of first - Stack Overflow](https://stackoverflow.com/questions/34820018/get-the-focus-in-a-buttongroup-of-jradiobuttons-to-go-to-the-currently-selected/34832814#34832814)
- [JDK-8033699 Incorrect radio button behavior - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8033699)

<!-- dummy comment line for breaking list -->

## コメント
