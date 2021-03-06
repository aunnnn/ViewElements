//
//  lang_es.swift
//  SwiftDate
//
//  Created by Daniele Margutti on 13/06/2018.
//  Copyright © 2018 SwiftDate. All rights reserved.
//

import Foundation

// swiftlint:disable type_name
public class lang_esPY: RelativeFormatterLang {

	/// Locales.spanishParaguay
	public static let identifier: String = "es_PY"

	public required init() {}

	public func quantifyKey(forValue value: Double) -> RelativeFormatter.PluralForm? {
		return (value == 1 ? .one : .other)
	}

	public var flavours: [String: Any] {
		return [
			RelativeFormatter.Flavour.long.rawValue: self._long,
			RelativeFormatter.Flavour.narrow.rawValue: self._narrow,
			RelativeFormatter.Flavour.short.rawValue: self._short
		]
	}

	private var _short: [String: Any] {
		return [
			"year": [
				"previous": "el año pasado",
				"current": "este año",
				"next": "el próximo año",
				"past": "hace {0} a",
				"future": "en {0} a"
			],
			"quarter": [
				"previous": "el trimestre pasado",
				"current": "este trimestre",
				"next": "el próximo trimestre",
				"past": "hace {0} trim.",
				"future": [
					"one": "en {0} trim.",
					"other": "en {0} trim"
				]
			],
			"month": [
				"previous": "el mes pasado",
				"current": "este mes",
				"next": "el próximo mes",
				"past": "hace {0} m",
				"future": "en {0} m"
			],
			"week": [
				"previous": "la semana pasada",
				"current": "esta semana",
				"next": "la semana próxima",
				"past": "hace {0} sem.",
				"future": "en {0} sem."
			],
			"day": [
				"previous": "ayer",
				"current": "hoy",
				"next": "mañana",
				"past": [
					"one": "hace {0} día",
					"other": "hace {0} días"
				],
				"future": [
					"one": "en {0} día",
					"other": "en {0} días"
				]
			],
			"hour": [
				"current": "esta hora",
				"past": "hace {0} h",
				"future": [
					"one": "en {0} h",
					"other": "en {0} n"
				]
			],
			"minute": [
				"current": "este minuto",
				"past": "hace {0} min",
				"future": "en {0} min"
			],
			"second": [
				"current": "ahora",
				"past": "hace {0} s",
				"future": "en {0} s"
			],
			"now": "ahora"
		]
	}

	private var _narrow: [String: Any] {
		return [
			"year": [
				"previous": "el año pasado",
				"current": "este año",
				"next": "el próximo año",
				"past": "-{0} a",
				"future": "en {0} a"
			],
			"quarter": [
				"previous": "el trimestre pasado",
				"current": "este trimestre",
				"next": "el próximo trimestre",
				"past": "-{0} T",
				"future": "+{0} T"
			],
			"month": [
				"previous": "el mes pasado",
				"current": "este mes",
				"next": "el próximo mes",
				"past": "-{0} m",
				"future": "+{0} m"
			],
			"week": [
				"previous": "la semana pasada",
				"current": "esta semana",
				"next": "la semana próxima",
				"past": "hace {0} sem.",
				"future": "dentro de {0} sem."
			],
			"day": [
				"previous": "ayer",
				"current": "hoy",
				"next": "mañana",
				"past": [
					"one": "hace {0} día",
					"other": "hace {0} días"
				],
				"future": [
					"one": "+{0} día",
					"other": "+{0} días"
				]
			],
			"hour": [
				"current": "esta hora",
				"past": "hace {0} h",
				"future": "dentro de {0} h"
			],
			"minute": [
				"current": "este minuto",
				"past": "-{0} min",
				"future": "+{0} min"
			],
			"second": [
				"current": "ahora",
				"past": "hace {0} s",
				"future": "+{0} s"
			],
			"now": "ahora"
		]
	}

	private var _long: [String: Any] {
		return [
			"year": [
				"previous": "el año pasado",
				"current": "este año",
				"next": "el año próximo",
				"past": [
					"one": "hace {0} año",
					"other": "hace {0} años"
				],
				"future": [
					"one": "dentro de {0} año",
					"other": "dentro de {0} años"
				]
			],
			"quarter": [
				"previous": "el trimestre pasado",
				"current": "este trimestre",
				"next": "el próximo trimestre",
				"past": [
					"one": "hace {0} trimestre",
					"other": "hace {0} trimestres"
				],
				"future": [
					"one": "dentro de {0} trimetre",
					"other": "dentro de {0} trimetres"
				]
			],
			"month": [
				"previous": "el mes pasado",
				"current": "este mes",
				"next": "el mes próximo",
				"past": [
					"one": "hace {0} mes",
					"other": "hace {0} meses"
				],
				"future": [
					"one": "en {0} mes",
					"other": "en {0} meses"
				]
			],
			"week": [
				"previous": "la semana pasada",
				"current": "esta semana",
				"next": "la semana próxima",
				"past": [
					"one": "hace {0} semana",
					"other": "hace {0} semanas"
				],
				"future": [
					"one": "dentro de {0} semana",
					"other": "dentro de {0} semanas"
				]
			],
			"day": [
				"previous": "ayer",
				"current": "hoy",
				"next": "mañana",
				"past": [
					"one": "hace {0} día",
					"other": "hace {0} días"
				],
				"future": [
					"one": "dentro de {0} día",
					"other": "dentro de {0} días"
				]
			],
			"hour": [
				"current": "esta hora",
				"past": [
					"one": "hace {0} hora",
					"other": "hace {0} horas"
				],
				"future": [
					"one": "dentro de {0} hora",
					"other": "dentro de {0} horas"
				]
			],
			"minute": [
				"current": "este minuto",
				"past": [
					"one": "hace {0} minuto",
					"other": "hace {0} minutos"
				],
				"future": [
					"one": "dentro de {0} minuto",
					"other": "dentro de {0} minutos"
				]
			],
			"second": [
				"current": "ahora",
				"past": [
					"one": "hace {0} segundo",
					"other": "hace {0} segundos"
				],
				"future": [
					"one": "dentro de {0} segundo",
					"other": "dentro de {0} segundos"
				]
			],
			"now": "ahora"
		]
	}
}
