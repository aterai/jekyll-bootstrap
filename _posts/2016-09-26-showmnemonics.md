---
layout: post
category: swing
folder: ShowMnemonics
title: JMenuItemなどのMnemonicの下線を常に表示する
tags: [JMenuItem, WindowsLookAndFeel, JButton, Mnemonic]
author: aterai
pubdate: 2016-09-26T01:36:44+09:00
description: WindowsLookAndFeelを使用する環境でJMenuItemやJButtonなどに設定したMnemonicの下線を常に表示するよう設定します。
image: https://drive.google.com/uc?id=1m64MGIgQ2o25gL3ZpVz_ZyEXU_TG2oZnAw
comments: true
---
## 概要
`WindowsLookAndFeel`を使用する環境で`JMenuItem`や`JButton`などに設定した`Mnemonic`の下線を常に表示するよう設定します。

{% download https://drive.google.com/uc?id=1m64MGIgQ2o25gL3ZpVz_ZyEXU_TG2oZnAw %}

## サンプルコード
<pre class="prettyprint"><code>showMnemonicsCheck.setSelected(UIManager.getBoolean("Button.showMnemonics"));
showMnemonicsCheck.setMnemonic('B');
showMnemonicsCheck.addActionListener(e -&gt; {
  UIManager.put("Button.showMnemonics", ((JCheckBox) e.getSource()).isSelected());
  if (UIManager.getLookAndFeel() instanceof WindowsLookAndFeel) {
    WindowsLookAndFeel.setMnemonicHidden(true);
    SwingUtilities.getRoot(showMnemonicsCheck).repaint();
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JMenuItem`に設定した`Mnemonic`の下線表示の切り替えをテストしています。

- `UIManager.put("Button.showMnemonics", false)`
    - `WindowsLookAndFeel`の場合、`Mnemonic`の下線が非表示になる
        - その他の`LookAndFeel`ではこの設定は無効
        - この場合でも<kbd>Alt</kbd>キーを押すと`WindowsLookAndFeel.setMnemonicHidden(false)`となって、下線は表示される
    - デフォルト
        - 例えば`Windows 10`の場合「コントロール パネル\コンピューターの簡単操作\コンピューターの簡単操作センター\キーボードを使いやすくします」の「ショートカット キーとアクセス キーに下線を表示します」のチェックに対応
    - `WindowsLookAndFeel`でチェックボックスで切り替えを行う際、`WindowsLookAndFeel.setMnemonicHidden(true)`で一旦下線を非表示にしてから`JFrame`全体を再描画している
        - [JDK-6921687 Mnemonic disappears after repeated attempts to open menu items using mnemonics - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6921687)
- `UIManager.put("Button.showMnemonics", true)`
    - `WindowsLookAndFeel`の場合でも`Mnemonic`の下線が常に表示状態になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Windows Look & Feelのキーボード・ナビゲーションの非表示](https://docs.oracle.com/javase/jp/8/docs/technotes/guides/swing/1.4/keyboard_nav_hiding.html)

<!-- dummy comment line for breaking list -->

## コメント
