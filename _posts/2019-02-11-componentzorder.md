---
layout: post
category: swing
folder: ComponentZOrder
title: JPanelに追加したコンポーネントの順序を変更する
tags: [JPanel, LayoutManager, GridLayout, GridBagLayout]
author: aterai
pubdate: 2019-02-11T21:46:54+09:00
description: JPanel内のコンポーネントのZ軸順インデックスを変更してその表示順序を変更します。
image: https://drive.google.com/uc?id=1mSe3NrxaEpAwsdupzRCA_Uv1RY8aaMXf5Q
comments: true
---
## 概要
`JPanel`内のコンポーネントの`Z`軸順インデックスを変更してその表示順序を変更します。

{% download https://drive.google.com/uc?id=1mSe3NrxaEpAwsdupzRCA_Uv1RY8aaMXf5Q %}

## サンプルコード
<pre class="prettyprint"><code>button.addActionListener(e -&gt; {
  p.setComponentZOrder(p.getComponent(p.getComponentCount() - 1), 0);
  p.revalidate();
});
</code></pre>

## 解説
- `GridLayout`を設定した`JPanel`に配置した`Z`軸順インデックスを変更
    - `GridLayout`は`JPanel`の`ComponentOrientation`が`LEFT_TO_RIGHT`の場合、`Z`軸順インデックスで左から右にコンポーネントを配置、表示する
        - `FlowLayout`、`BoxLayout`なども同様
- `GridBagLayout`を設定した`JPanel`に配置した`Z`軸順インデックスを変更
    - `GridBagConstraints.gridx`や`GridBagConstraints.gridy`のような位置に関する制約が指定されていない(デフォルトの`GridBagConstraints.RELATIVE`の状態)場合、`GridBagLayout`は`Z`軸順インデックスで左から右にコンポーネントを配置、表示する
        - 例えば`c.gridx = 0;`などの制約が設定されている場合、`setComponentZOrder(...)`メソッドで`Z`軸順インデックスを変更しても表示位置は変化しない
        - `BorderLayout`のように`BorderLayout.NORTH`などのレイアウト制約を設定してコンポーネントを配置している場合も同様に`Z`軸順インデックスを変更しても表示位置は変化しない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Container#setComponentZOrder(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Container.html#setComponentZOrder-java.awt.Component-int-)
- [JSplitPaneに設定した子コンポーネントの位置を入れ替える](https://ateraimemo.com/Swing/SwappingSplitPane.html)

<!-- dummy comment line for breaking list -->

## コメント
