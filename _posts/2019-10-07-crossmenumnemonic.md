---
layout: post
category: swing
folder: CrossMenuMnemonic
title: JMenuの表示中に別JMenu表示のMnemonicキーが入力された場合の動作を設定する
tags: [JMenu, Mnemonic, UIManager, LookAndFeel]
author: aterai
pubdate: 2019-10-07T15:56:56+09:00
description: トップレベルのJMenuの表示中に別のトップレベルJMenuを開くMnemonicキーが入力された場合、それらのポップアップ表示を切り替えるかどうかを設定します。
image: https://drive.google.com/uc?id=1dyq9CF4OHfr0yYxPQYInJOIbHQMEYtuJ
comments: true
---
## 概要
トップレベルの`JMenu`の表示中に別のトップレベル`JMenu`を開く`Mnemonic`キーが入力された場合、それらのポップアップ表示を切り替えるかどうかを設定します。

{% download https://drive.google.com/uc?id=1dyq9CF4OHfr0yYxPQYInJOIbHQMEYtuJ %}

## サンプルコード
<pre class="prettyprint"><code>String key = "Menu.crossMenuMnemonic";

boolean b = UIManager.getBoolean(key);
System.out.println(key + ": " + b);
JCheckBox check = new JCheckBox(key, b) {
  @Override public void updateUI() {
    super.updateUI();
    setSelected(UIManager.getLookAndFeelDefaults().getBoolean(key));
    UIManager.put(key, isSelected());
  }
};
check.addActionListener(e -&gt; {
  UIManager.put(key, ((JCheckBox) e.getSource()).isSelected());
  SwingUtilities.updateComponentTreeUI(getRootPane().getJMenuBar());
});
</code></pre>

## 解説
- `Menu.crossMenuMnemonic`: `true`
    - `MetalLookAndFeel`、`MotifLookAndFeel`のデフォルト
    - トップレベルの`JMenu`の表示中に別のトップレベル`JMenu`を開く`Mnemonic`キーが入力された場合、別のトップレベル`JMenu`のポップアップに切り替わる
    - たとえばこのサンプルで<kbd>Alt+F</kbd>、<kbd>Alt+E</kbd>を入力すると`Edit`メニューがポップアップ表示状態になる
- `Menu.crossMenuMnemonic`: `false`
    - `WindowsLookAndFeel`、`NimbusLookAndFeel`のデフォルト
    - トップレベルの`JMenu`の表示中に別のトップレベル`JMenu`を開く`Mnemonic`キーが入力されても無視される(元のトップレベル`JMenu`のポップアップ表示が継続する)
    - たとえばこのサンプルで<kbd>Alt+F</kbd>、<kbd>Alt+E</kbd>を入力すると`File`メニューがポップアップ表示状態になる

<!-- dummy comment line for breaking list -->

- - - -
- トップレベルではない`JMenu`(`JToolBar`直下ではなく、`JPopupMenu`以下に追加されている`JMenu`)にはこの設定は無関係
- `UIManager.put("Menu.crossMenuMnemonic", ...);`で設定を切り替えた場合、`SwingUtilities.updateComponentTreeUI(...)`などで`LoolAndFeel`の`UI`プロパティを更新する必要がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [&#91;JDK-6674479&#93; Incorrect cycling between conflicting mnemonics in menu - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6674479)

<!-- dummy comment line for breaking list -->

## コメント
