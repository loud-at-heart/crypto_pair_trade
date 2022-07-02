import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:crypto_pair_trade/models/currency_data.dart';
import 'package:crypto_pair_trade/models/order_book_data.dart';
import 'package:crypto_pair_trade/modules/crypto_trade_route/bloc/crypto_trade_bloc.dart';
import 'package:crypto_pair_trade/resources/strings/app_strings.dart';
import 'package:crypto_pair_trade/style/app_text_styles.dart';
import 'package:crypto_pair_trade/style/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CryptoDashboard extends StatefulWidget {
  const CryptoDashboard({Key? key}) : super(key: key);

  @override
  State<CryptoDashboard> createState() => _CryptoDashboardState();
}

class _CryptoDashboardState extends State<CryptoDashboard> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  TextEditingController filterTextEditingController = TextEditingController();
  bool isLoading = false;
  bool showOrderBook = false;
  CurrencyData currencyData = CurrencyData();
  OrderBookData orderBookData = OrderBookData();

  format(DateTime date) {
    var suffix = "th";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    return DateFormat("d'$suffix' MMM yyyy, HH:mm:ss").format(date);
  }

  var currencyFormat =
  NumberFormat.currency(
    symbol: '\$ ',
    locale: "EN",

  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CryptoTradeBloc, CryptoTradeState>(
        listener: (context, state) {
          if (state is ServerResponse) {
            setState(() {
              currencyData = state.currencyData;
              orderBookData = state.orderBookData;
            });
          } else if (state is LoadingState) {
            setState(() {
              isLoading = state.showLoader;
            });
          } else if (state is NoInternetState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('No Internet Connection'),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  textColor: Colors.white,
                ),
              ),
            );
          } else if (state is RequestFailedWithMessageState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  textColor: Colors.white,
                ),
              ),
            );
          } else if (state is NoInputState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Enter a currency pair to load data'),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  textColor: Colors.white,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: Spacing.smallMargin,
                right: Spacing.smallMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  filterSearch,
                  if (filterTextEditingController.text.isEmpty && !isLoading)
                    ...emptyScreenWidget,
                  if (filterTextEditingController.text.isNotEmpty &&
                      currencyData.ask != null &&
                      !isLoading)
                    ...currencyDataWidget,
                  if (filterTextEditingController.text.isNotEmpty &&
                      showOrderBook)
                    ...orderBookWidget,
                  if (isLoading) ...[
                    Spacing.sizeBoxHt100,
                    const Center(child: CircularProgressIndicator()),
                  ]
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          currencyData = CurrencyData();
          orderBookData = OrderBookData();
          showOrderBook = false;
          filterTextEditingController.clear();
          BlocProvider.of<CryptoTradeBloc>(context)
              .add(GetCurrencyData(currency: filterTextEditingController.text));
        }),
        child: const RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.loop),
        ),
        backgroundColor: const Color(0xff6E00F8),
      ),
    );
  }

  Widget get filterSearch => Padding(
        padding: const EdgeInsets.only(
          right: Spacing.defaultMargin,
          left: Spacing.defaultMargin,
          top: Spacing.margin40,
        ),
        child: SimpleAutoCompleteTextField(
          key: key,
          controller: filterTextEditingController,
          suggestions: AppStrings.suggestions,
          clearOnSubmit: false,
          textSubmitted: (text) => BlocProvider.of<CryptoTradeBloc>(context)
            ..add(GetCurrencyData(currency: text)),
          textChanged: (text) {
            setState(() {
              currencyData = CurrencyData();
              orderBookData = OrderBookData();
              showOrderBook = false;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.only(
                left: Spacing.defaultMargin, top: Spacing.defaultMargin),
            filled: true,
            fillColor: const Color(0xFFF4F4F4),
            hintText: 'Enter Currency Pair',
            suffixIcon: IconButton(
              onPressed: () => filterTextEditingController.text.isNotEmpty
                  ? BlocProvider.of<CryptoTradeBloc>(context).add(
                      GetCurrencyData(
                          currency: filterTextEditingController.text))
                  : null,
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );

  List<Widget> get emptyScreenWidget => [
        const Center(child: Spacing.sizeBoxHt40),
        const Center(
          child: Icon(
            Icons.search,
            size: 200,
            color: Color(0xFFAAA7A7),
          ),
        ),
        const Center(
          child: Text(
            'Enter a currency pair to load data',
            style: TextStyle(fontSize: FontSize.subtitle),
          ),
        )
      ];

  List<Widget> get currencyDataWidget => [
        Spacing.sizeBoxHt40,
        Padding(
          padding: const EdgeInsets.only(
            left: Spacing.smallMargin,
            right: Spacing.smallMargin,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      filterTextEditingController.text.toUpperCase(),
                      style: AppTextStyles.mediumRoboto(
                          FontSize.large36, Colors.black),
                    ),
                  ),
                  Text(
                    format(DateTime.fromMillisecondsSinceEpoch(
                        int.parse(currencyData.timestamp ?? '') * 1000)),
                    style: AppTextStyles.regularRoboto(
                        FontSize.small, Colors.black),
                  ),
                ],
              ),
              Spacing.sizeBoxHt20,
              Row(
                children: [
                  dataToken(
                    'open',
                    currencyData.open ?? '',
                  ),
                  Spacing.sizeBoxWt100,
                  dataToken(
                    'high',
                    currencyData.high ?? '',
                  ),
                ],
              ),
              Spacing.sizeBoxHt30,
              Row(
                children: [
                  dataToken(
                    'low',
                    currencyData.low ?? '',
                  ),
                  Spacing.sizeBoxWt100,
                  dataToken(
                    'last',
                    currencyData.last ?? '',
                  ),
                ],
              ),
              Spacing.sizeBoxHt30,
              Row(
                children: [
                  dataToken(
                    'volume',
                    currencyData.volume ?? '',
                  ),
                ],
              ),
              Spacing.sizeBoxHt20,
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    child: Text(
                      showOrderBook
                          ? AppStrings.hideOrderBook
                          : AppStrings.viewOrderBook,
                      style: AppTextStyles.mediumRoboto(
                        FontSize.normal,
                        const Color(0xff6E00F8),
                      ).copyWith(
                        letterSpacing: Spacing.tinyMargin,
                      ),
                    ),
                    onTap: () => setState(() {
                      showOrderBook = !showOrderBook;
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
      ];

  List<Widget> get orderBookWidget => [
        Spacing.sizeBoxHt20,
        Text(
          AppStrings.orderBook,
          style: AppTextStyles.mediumRoboto(
            FontSize.small,
            Colors.black,
          ).copyWith(
            letterSpacing: Spacing.tinyMargin,
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.smallMargin),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      AppStrings.bidPrice,
                      style: AppTextStyles.mediumRoboto(
                        FontSize.tiny,
                        Colors.black,
                      ).copyWith(
                        letterSpacing: Spacing.tinyMargin,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppStrings.qty,
                      style: AppTextStyles.mediumRoboto(
                        FontSize.tiny,
                        Colors.black,
                      ).copyWith(
                        letterSpacing: Spacing.tinyMargin,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppStrings.qty,
                      style: AppTextStyles.mediumRoboto(
                        FontSize.tiny,
                        Colors.black,
                      ).copyWith(
                        letterSpacing: Spacing.tinyMargin,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppStrings.askPrice,
                      style: AppTextStyles.mediumRoboto(
                        FontSize.tiny,
                        Colors.black,
                      ).copyWith(
                        letterSpacing: Spacing.tinyMargin,
                      ),
                    ),
                  ],
                ),
                Spacing.sizeBoxHt15,
                for (var i = 0; i < 5; i++) ...[
                  Row(
                    children: [
                      Text(
                        orderBookData.bids?[i][0],
                        style: AppTextStyles.regularRoboto(
                          FontSize.tiny,
                          Colors.black,
                        ).copyWith(
                          letterSpacing: Spacing.tinyMargin,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        orderBookData.bids?[i][1],
                        style: AppTextStyles.regularRoboto(
                          FontSize.tiny,
                          Colors.black,
                        ).copyWith(
                          letterSpacing: Spacing.tinyMargin,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        orderBookData.asks?[i][1],
                        style: AppTextStyles.regularRoboto(
                          FontSize.tiny,
                          Colors.black,
                        ).copyWith(
                          letterSpacing: Spacing.tinyMargin,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        orderBookData.asks?[i][0],
                        style: AppTextStyles.regularRoboto(
                          FontSize.tiny,
                          Colors.black,
                        ).copyWith(
                          letterSpacing: Spacing.tinyMargin,
                        ),
                      ),
                    ],
                  ),
                  Spacing.sizeBoxHt15,
                ]
              ],
            ),
          ),
        )
      ];

  Widget dataToken(String title, String data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.mediumRoboto(
              FontSize.tiny,
              Colors.black,
            ).copyWith(
              letterSpacing: Spacing.tinyMargin,
            ),
          ),
          Spacing.sizeBoxHt2,
          Text(
            title == 'volume'
                ? data
                : currencyFormat.format(double.parse(data.split('.')[0]))+data.split('.')[1],
            style: AppTextStyles.mediumRoboto(
              FontSize.title,
              Colors.black,
            ),
          ),
        ],
      );
}
